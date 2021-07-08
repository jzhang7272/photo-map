//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "PhotoMapViewController.h"
#import "LocationsViewController.h"

@interface PhotoMapViewController () <UIImagePickerControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:false];
    
    self.mapView.delegate = self;
    
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}
- (IBAction)onTapCamera:(id)sender {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    self.selectedImage = (editedImage != nil) ? editedImage : originalImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"tagSegue" sender:nil];
}

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    [self.navigationController popViewControllerAnimated:true];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = @"Picture!";
    [self.mapView addAnnotation:annotation];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
     MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
     if (annotationView == nil) {
         annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
         annotationView.canShowCallout = true;
         annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
     }

     UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    imageView.image = self.selectedImage;
    // [UIImage imageNamed:@"camera"];

     return annotationView;
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tagSegue"]) {
            LocationsViewController *vc = segue.destinationViewController;
            vc.delegate = self;
    }
}


@end
