#import "OLWindowController.h"
#import "OLMainController.h"
#import "OLConnectionController.h"
#import "OLDatabaseController.h"
#import <PSMTabBarControl/PSMTabBarControl.h>
#import <PSMTabBarControl/PSMTabStyle.h>

@implementation OLWindowController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [tabBar setCellMinWidth:100];
    [tabBar setCellMaxWidth:250];
    [tabBar setCellOptimumWidth:250];
    [tabBar setCanCloseOnlyTab:NO];
    [tabBar setHideForSingleTab:NO];
    [tabBar setSelectsTabsOnMouseDown:YES];    
    [tabBar setShowAddTabButton:YES];
    [tabBar setTearOffStyle:PSMTabBarTearOffAlphaWindow];    
    [tabBar setSizeCellsToFit:NO];
    
    // Hook up add tab button
    [[tabBar addTabButton] setTarget:self];
	[[tabBar addTabButton] setAction:@selector(addTabPanel:)];
    
}



- (BOOL)tabView:(NSTabView*)aTabView shouldDragTabViewItem:(NSTabViewItem *)tabViewItem 
     fromTabBar:(PSMTabBarControl *)tabBarControl 
{
	return YES;
}

- (BOOL)tabView:(NSTabView*)aTabView shouldDropTabViewItem:(NSTabViewItem *)tabViewItem 
       inTabBar:(PSMTabBarControl *)tabBarControl 
{
	return YES;
}

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{

    NSTabViewItem *tabItem = [tabView selectedTabViewItem];
    
    if ([[tabItem identifier] isKindOfClass:[OLDatabaseController class]]) {
        [toolbarController setDbController:[tabItem identifier]];        
    }
    else {
        [toolbarController setDbController:nil];        
    }

}

- (IBAction)closeTab:(id)sender
{
	if ([tabView numberOfTabViewItems] > 1) {
		[tabView removeTabViewItem:[tabView selectedTabViewItem]];
	} 
	else {
		[[self window] performClose:self];
	}
}


- (IBAction)addTabPanel:(id)sender
{
    printf("addTabPanel\n");
    
    OLConnectionController *newController =
        [[OLConnectionController alloc] 
         initWithNibName:@"ConnectionView" 
         bundle:nil];
    
    [newController setDelegate:self];

    NSTabViewItem *newTabItem = [[NSTabViewItem alloc] 
                                 initWithIdentifier:(id)newController];

    [newTabItem setView:[newController view]];
    [tabView addTabViewItem:newTabItem];
    [tabView selectTabViewItem:newTabItem];
    
    NSLog(@"Tab identifier: %@", [newTabItem identifier]);
        
}

- (IBAction)openConnection:(id)connection
{
    NSLog(@"Opening the connection ");
    
    NSTabViewItem *tabItem = [tabView selectedTabViewItem];
    NSView *tabItemView = [tabItem view];

    OLDatabaseController * dbController = 
        [[OLDatabaseController alloc]
         initWithNibName:@"DatabaseView" bundle:nil];    
    
    [tabItem setLabel: [connection name]];
    [tabItem setView:[dbController view]];
    [tabItem setIdentifier:dbController];
    
    [dbController setConnection: connection];
    [toolbarController setDbController:dbController];

    // Deallocate the old view (connectionView)
    [tabItemView dealloc];
    
    
    
}

@end
