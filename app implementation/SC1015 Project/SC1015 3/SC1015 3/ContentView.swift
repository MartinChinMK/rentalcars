import SwiftUI
import MapKit
import BottomSheet
import Charts

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
    
    var demoData: [(String, Double)] = [
        ("M", 2.2),
        ("T", 2.8),
        ("W", 3.2),
        ("T", 3.0),
        ("F", 2.1),
        ("S", 1.3),
        ("S", 1.7)]
    
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
                Text(self.bottomSheetName)
                    .font(.title).bold()
                
                Text("BlueSG availability for next 7 days")
                    .font(.subheadline).foregroundColor(.secondary)
                
                Divider()
                    .padding(.trailing, -30)
            }
        }) {
            Bar(entries: [
                BarChartDataEntry(x: 1, y: 22/40*100),
                BarChartDataEntry(x: 2, y: 26/40*100),
                BarChartDataEntry(x: 3, y: 31/40*100),
                BarChartDataEntry(x: 4, y: 33/40*100),
                BarChartDataEntry(x: 5, y: 21/40*100),
                BarChartDataEntry(x: 6, y: 8/40*100),
                BarChartDataEntry(x: 7, y: 12/40*100)
            ])
        }
    }
}

struct Bar : UIViewRepresentable {
    //Bar chart accepts data as array of BarChartDataEntry objects
    var entries : [BarChartDataEntry]
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> BarChartView {
        //crate new chart
        let chart = BarChartView()
        //it is convenient to form chart data in a separate func
        chart.data = addData()
        chart.legend.enabled = false
        chart.extraTopOffset = 0
        chart.setVisibleYRangeMinimum(100, axis: .left)
        chart.setVisibleYRangeMaximum(100, axis: .left)
        chart.moveViewToY(50, axis: .left)
        chart.getAxis(.right).enabled = false
        chart.getAxis(.left).drawGridLinesEnabled = false
        chart.getAxis(.left).drawLabelsEnabled = false
        chart.getAxis(.left).drawAxisLineEnabled = false
        chart.getAxis(.left).axisMaximum = 100
        chart.getAxis(.left).axisMinimum = 0
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.valueFormatter = DayFormatter()
        chart.xAxis.drawAxisLineEnabled = false
        
        return chart
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: BarChartView, context: Context) {
        //when data changes chartd.data update is required
        uiView.data = addData()
    }
    
    func addData() -> BarChartData{
        let data = BarChartData()
        //BarChartDataSet is an object that contains information about your data, styling and more
        let dataSet = BarChartDataSet(entries: entries)
        // change bars color to green
        dataSet.colors = [
            NSUIColor.systemPink,
            NSUIColor.systemCyan,
            NSUIColor.systemCyan,
            NSUIColor.systemCyan,
            NSUIColor.systemCyan,
            NSUIColor.systemCyan,
            NSUIColor.systemCyan
            ]
        //change data label
        dataSet.label = "My Data"
        dataSet.valueFormatter = PercentFormatter()
        dataSet.valueFont = UIFont.systemFont(ofSize: 12)
        data.dataSets = [dataSet]
        return data
    }
    
    typealias UIViewType = BarChartView
    
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

class DayFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch value {
        case 1: return "10 Apr"
        case 2: return "11 Apr"
        case 3: return "12 Apr"
        case 4: return "13 Apr"
        case 5: return "14 Apr"
        case 6: return "15 Apr"
        case 7: return "16 Apr"
        default: return "17 Apr"
        }
    }
}

class PercentFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(lround(value)) + "%"
    }
}
