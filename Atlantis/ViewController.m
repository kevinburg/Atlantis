//
//  ViewController.m
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import "ConnectionViewController.h"
#import "AtlantisTableCell.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate,
    UITableViewDataSource,
    UITableViewDelegate>
    // central
    @property (strong, nonatomic) CBCentralManager      *centralManager;
    @property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
    @property (strong, nonatomic) NSMutableData         *data;
    // peripheral
    @property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
    @property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
    @property (strong, nonatomic) NSData                    *dataToSend;
    @property (nonatomic, readwrite) NSInteger              sendDataIndex;

    @property (strong, nonatomic) NSMutableArray *connections;
    @property NSString *conn;
    @property (strong, nonatomic) UIRefreshControl *refreshControl;
    @property (strong, nonatomic) IBOutlet UITableView *table;

@end


@implementation ViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    [self setConnections:[[NSMutableArray alloc] init]];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionMade)
                                                 name:@"ConnectionNotification"
                                               object:nil];*/

    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // And somewhere to store the incoming data
    _data = [[NSMutableData alloc] init];
    
    // Start up the CBPeripheralManager
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    

    
}

- (void)refreshDisplay:(UITableView *)tableView {
    NSLog(@"reload");
    [tableView reloadData];
}

/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        // Bluetooth is on
        
        // Update our status label
        //self.statusLabel.text = @"Scanning...";
        
        // ... so start scanning
        [self scan];
    }
    else if (central.state == CBCentralManagerStatePoweredOff)
    {
        // Update our status label
        //self.statusLabel.text = @"Stopped";
        
        // Bluetooth isn't on. Stop broadcasting
        //[self.peripheralManager stopAdvertising];
    }
    else if (central.state == CBCentralManagerStateUnsupported)
    {
        //self.statusLabel.text = @"Unsupported";
    }
    //OLD
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    
    
}

/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSLog(@"Scanning started");
}

/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Reject any where the value is above reasonable range
    
    /*if (RSSI.integerValue > -15) {
        NSLog(@"Too close");
        return;
    }
     */
    
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    if (RSSI.integerValue < -35) { // was 35
        NSLog(@"Too far");
        return;
    }
    
    //NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    // Ok, it's in range - have we already seen it?
    if (self.discoveredPeripheral != peripheral) {
        
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //NSLog(@"Peripheral Connected");
    
    // Stop scanning
    [self.centralManager stopScan];
    //NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}


/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Discover the characteristic we want...
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%@,%@",self.table.delegate, self.table.dataSource);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.connections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell");
    AtlantisTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AtlantisTableCell"
                                                                forIndexPath:indexPath];
    NSString *conn = self.connections[[indexPath row]];

    [cell.cellLabel setText:[NSString stringWithFormat:@"Continue with %@", conn]];
    
    cell.cellImage.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
    
    dispatch_async(kBgQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", conn]]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AtlantisTableCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.cellImage.image = image;
                });
            }
        }
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *conn = self.connections[[indexPath row]];
    self.conn = conn;
    [self performSegueWithIdentifier:@"ConnectSegue" sender:self];
    return;
}


/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        NSString *id = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        

        
            if ([self.connections containsObject:id]) {
            } else {
                // We have, so show the data,
                //self.foundLabel.text = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
                //[self.textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        
                // Cancel our subscription to the characteristic
                [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
                // and disconnect from the peripehral
                [self.centralManager cancelPeripheralConnection:peripheral];
        
        
                /*[[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectionNotification"
                                                                object:self];*/
                [self.connections addObject:id];
                NSLog(@"Reload");
                //[self performSelector:(@selector(refreshDisplay:)) withObject:(self.table) afterDelay:0.5];
                [self.table reloadData];
            }
    }
    
    // Otherwise, just add the data on to what we already have
    [self.data appendData:characteristic.value];
    
    // Log it
    //NSLog(@"Received: %@", stringFromData);
}

- (void)connectionMade
{
    // This function is called once the user logs into Atlantis
    [self performSegueWithIdentifier:@"ConnectSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConnectSegue"]) {
        ConnectionViewController * homeController =[segue destinationViewController];
        homeController.connectionLabelText = self.conn;
        
    } else {
        NSLog(@"Invalid segue attempted from JettaLoginViewController. ");
   
    }
}



/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}


/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    
    // We're disconnected, so start scanning again
    [self scan];
}


/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!self.discoveredPeripheral.isConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

#pragma mark - Peripheral Methods

/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on

        NSLog(@"self.peripheralManager powered on.");

        
        // Update our status label
        //self.statusLabel.text = @"Broadcasting...";
        
        // Start with the CBMutableCharacteristic
        self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                         properties:CBCharacteristicPropertyNotify
                                                                              value:nil
                                                                        permissions:CBAttributePermissionsReadable];
        
        // Then the service
        CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                           primary:YES];
        
        // Add the characteristic to the service
        transferService.characteristics = @[self.transferCharacteristic];
        
        // And add it to the peripheral manager
        [self.peripheralManager addService:transferService];
        
        // All we advertise is our service's UUID
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        //self.statusLabel.text = @"Stopped";
        
        // Bluetooth isn't on. Stop broadcasting
        //[self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        //self.statusLabel.text = @"Unsupported";
    }
    
    
    
}

/** Catch when someone subscribes to our characteristic, then start sending them data
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    //NSLog(@"Central subscribed to characteristic");
    
    // Get the data
    self.dataToSend = [self.id dataUsingEncoding:NSUTF8StringEncoding];
    
    // Reset the index
    self.sendDataIndex = 0;
    
    // Start sending
    [self sendData];
}


/** Recognise when the central unsubscribes
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    //NSLog(@"Central unsubscribed from characteristic");
}


/** Sends the next amount of data to the connected central
 */
- (void)sendData
{
    // First up, check if we're meant to be sending an EOM
    static BOOL sendingEOM = NO;
    
    if (sendingEOM) {
        
        // send it
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // Did it send?
        if (didSend) {
            
            // It did, so mark it as sent
            sendingEOM = NO;
            
            //NSLog(@"Sent: EOM");
        }
        
        // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    
    // We're not sending an EOM, so we're sending data
    
    // Is there any left to send?
    
    if (self.sendDataIndex >= self.dataToSend.length) {
        
        // No data left.  Do nothing
        return;
    }
    
    // There's data left, so send until the callback fails, or we're done.
    
    BOOL didSend = YES;
    
    while (didSend) {
        
        // Make the next chunk
        
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        
        // Send it
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            // It was - send an EOM
            
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            
            // Send it
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                
                // NSLog(@"Sent: EOM");
            }
            
            return;
        }
    }
}


/** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
 *  This is to ensure that packets will arrive in the order they are sent
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    // Start sending again
    [self sendData];
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.centralManager stopScan];
    NSLog(@"Scanning and Advertising stopped: Disappearing");
    
    // Don't keep it going while we're not showing.
    [self.peripheralManager stopAdvertising];
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
