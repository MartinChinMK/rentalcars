import SwiftUI
import MapKit
import BottomSheet
import SwiftUICharts

//The custom BottomSheetPosition enum with absolute values.
enum BookBottomSheetPosition: CGFloat, CaseIterable {
    case middle = 325, bottom = 125, hidden = 0
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.3437, longitude: 103.68541), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State var bottomSheetPosition: BookBottomSheetPosition = .hidden
    @State var bottomSheetName = ""
    
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    let locations = [
        Location(name: "953 Jurong West Street 91", coordinate: CLLocationCoordinate2D(latitude: 1.3424127505647119, longitude: 103.69063472264737)),
        Location(name: "903 Jurong West Street 91", coordinate: CLLocationCoordinate2D(latitude: 1.3397098246517167, longitude: 103.68617152688654)),
        Location(name: "832A Jurong West Street 81", coordinate: CLLocationCoordinate2D(latitude: 1.344473216764973, longitude: 103.6943068575654)),
        Location(name: "986 Jurong West Street 93", coordinate: CLLocationCoordinate2D(latitude: 1.3368772869861, longitude: 103.69446635543169)),
        Location(name: "624A Jurong West Street 61", coordinate: CLLocationCoordinate2D(latitude: 1.341127998081277, longitude: 103.69841708441206)),
        Location(name: "854A Jurong West Street 81", coordinate: CLLocationCoordinate2D(latitude: 1.3476736427878633, longitude: 103.69621781322272))
    ]
        
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: locations) {
            location in MapAnnotation(coordinate: location.coordinate) {
                PlaceAnnotationView(title: location.name)
                    .onTapGesture {
                        bottomSheetPosition = .middle
                        bottomSheetName = location.name
                        
                        // TODO: Zoom
                    }
                }
            }
    .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noDragIndicator, .allowContentDrag, .showCloseButton(), .swipeToDismiss, .absolutePositionValue], headerContent: {
            //The name of the book as the heading and the author as the subtitle with a divider.
            VStack(alignment: .leading) {
                Text( self.bottomSheetName)
                    .font(.title).bold()
                
                Divider()
                    .padding(.trailing, -30)
            }
        }) {
            BarChart()
                .data(demoData)
        }
    }
}

struct PlaceAnnotationView: View {
    @State private var showTitle = true
    
    let title: String
    
  var body: some View {
      VStack(spacing: 0) {
            Text(title)
              .font(.callout)
              .padding(5)
              .background(Color(.white))
              .cornerRadius(10)
            
            Image(systemName: "mappin.circle.fill")
              .font(.title)
              .foregroundColor(.red)
            
            Image(systemName: "arrowtriangle.down.fill")
              .font(.caption)
              .foregroundColor(.red)
              .offset(x: 0, y: -5)
          }
  }
}
