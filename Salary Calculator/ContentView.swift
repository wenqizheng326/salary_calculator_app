//
//  ContentView.swift
//  Salary Calculator
//
//  Created by Wenqi Zheng on 7/5/24.
//

import SwiftUI

struct ContentView: View {
    @State var jobName: String = ""
    @State var showInputJobNameScreen: Bool = false
    @State var jobList: [String] = []
    
    @State private var stackPath: [String] = []
    
    var body: some View {
        NavigationStack(path: $stackPath){
            ZStack{
                Color("Background")
                    .ignoresSafeArea()
                VStack{
                    // MARK: Dashboard Total overall income
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Dashboard"))
                            .frame(minWidth: 100, maxWidth: 350, maxHeight: 160)
                            .padding(5)
                            .shadow(radius: 10)
                        
                        VStack{
                            Text("Total Overall Income")
                                .font(.title2)
                                .padding(.top, 17)
                                .padding(.leading, 17)
                                .padding(.bottom, 5)
                                .foregroundColor(.white)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("$0.00")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                        .frame(maxWidth: 350, maxHeight: 160, alignment: .topLeading)
                        
                    }
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
                    List{
                        ForEach(jobList, id: \.self){ job in
                            NavigationLink("\(job)",destination: HoursScreen(jobName: job))
                        }
                    }
                    
                    //MARK: JobInput Screen
                    HStack{
                        Spacer()
                        Button(action:{
                            showInputJobNameScreen.toggle()
                        }, label:{
                            Circle()
                                .fill(Color("AddButton"))
                                .frame(width: 70, height: 70, alignment: .trailing)
                                .shadow(radius: 15)
                                .overlay{
                                    Image(systemName: "plus")
                                        .accentColor(.white)
                                        .font(.system(size: 30))
                                        .bold()
                                }
                                .padding(.trailing,50)
                                .padding(.bottom,30)
                        })
                    }
                }
                
                if(showInputJobNameScreen){
                    InputJobNameScreen(showInputJobScreen: $showInputJobNameScreen, jobName: $jobName, jobList: $jobList)
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

// MARK: Jobname input alert
struct InputJobNameScreen: View{
    @Environment(\.presentationMode) var presentationMode
    @Binding var showInputJobScreen: Bool
    @Binding var jobName: String
    @Binding var jobList: [String]
    
    @FocusState private var focus: Bool
    
    var body: some View{
        Color(.gray)
            .opacity(0.5)
            .ignoresSafeArea()
        
        Spacer()
        ZStack{
            Rectangle()
                .fill(.white)
                .frame(maxWidth: 280, maxHeight: 170)
                .cornerRadius(10)
                .shadow(radius: 10)
                
                .overlay{
                    VStack(spacing: 0,content:{
                        Text("Enter Job Name")
                            .foregroundColor(.black)
                            .padding(.top,20)
                            .bold()
                        
                        TextField("Type name", text: $jobName)
                            .padding(10)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2).cornerRadius(10))
                            .padding(15)
                            .padding(.bottom,-15)
                            .focused($focus)
                            .submitLabel(.done)
                            .onSubmit {
                                if jobName != ""{
                                    jobList.append(jobName)
                                    showInputJobScreen = false
                                    jobName = ""
                                }
                            }
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: 280,maxHeight: 0.5)
                            .padding(.top,25)
                        
                        HStack(spacing: 0, content: {
                            // cancel to go back
                            Button(action:{
                                showInputJobScreen = false
                            }, label: {
                                Rectangle()
                                    .fill(.white)
                                    .frame(maxWidth: 140,maxHeight: 50)
                                    .cornerRadius(10)
                                    .overlay{
                                        Text("Cancel")
                                            .foregroundColor(.gray)
                                            .bold()
                                    }
                            })
                            
                            Rectangle()
                                .fill(.gray)
                                .frame(maxWidth: 0.2,maxHeight: 50)
                            
                                
                            Button(action: {
                                if jobName != ""{
                                    jobList.append(jobName)
                                    jobName = ""
                                    showInputJobScreen = false
                                }
                                
                            }, label: {
                                Rectangle()
                                    .fill(.white)
                                    .frame(maxWidth: 140,maxHeight: 50)
                                    .cornerRadius(10)
                                    .overlay{
                                        Text("Enter")
                                            .bold()
                                            .foregroundColor(.blue)
                                    }
                            })
                            
                        })
                    })
                }
        }
        .onAppear{
            focus = true
        }
        
        Spacer()
    }
}


//MARK: Job Hours input screen
struct HoursScreen: View{
    @State var selectedDate: Date = Date()
    @State var selectedStart: Date = Date()
    @State var selectedEnd: Date = Date()
    @State var selectionStep: Int = 0
    @State var showHourPopUp: Bool = false
    @State var hourList: [[Date]] = []
    @State var numHoursList: [Double] = []
    
    @State var rate: Double = 0.00
    @State var showRateInput: Bool = false
    
    @State var jobName: String
    
    
    var totalHrs: Double{
        numHoursList.reduce(0, +)
    }
    
    var jobscreenIncome: Double{
        rate*totalHrs
    }
    
    var body: some View{
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            
            VStack{
                
                Button(action:{
                    rate = 0.0
                    hourList = []
                    numHoursList = []
                }, label:{
                    Text("Clear")
                        .frame(maxWidth: .infinity,alignment: .trailing)
                        .font(.headline)
                        .padding(.trailing,15)
                        .foregroundColor(Color("AddButton"))
                })
                
                Text("\(jobName) Total Income")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(5)
                    .foregroundColor(Color("TextColor"))
                    .font(.title3)
                    .bold()
                
                Text("$\(jobscreenIncome, specifier: "%.2f")")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(20)
                    .padding(.leading,-10)
                    .foregroundColor(Color("TextColor3"))
                    .font(.largeTitle)
                    .bold()
                
                
                HStack{
                    
                    Button(action:{
                        showRateInput.toggle()
                    }, label: {
                        Text("Rate: \(rate, specifier: "%.2f")")
                            .foregroundColor(Color("TextColor3"))
                            .font(.title3)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.leading,15)
                            .bold()
                    })
                    Button(action:{
                        withAnimation(.easeIn){
                            showHourPopUp.toggle()
                        }
                    }, label: {
                        Text("Add Hours")
                            .foregroundColor(Color("TextColor"))
                            .font(.title3)
                            .frame(maxWidth: .infinity,alignment: .trailing)
                            .padding(.trailing,15)
                            .bold()
                    })
                }
                
                // header with date, start, end
                HStack{
                    Text("Date")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,10)
                    
                    Spacer()
                    Text("Start")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.trailing,30)
                    Spacer()
                    
                    Text("End")
                        .padding(.trailing,50)
                    Spacer()
                    Text("Hrs")
                        .padding(.trailing,10)
                    Spacer()
                }
                .padding(10)
                .background(Color(hex:"#3a717e"))
                .foregroundColor(Color("InvertTextColor"))
                
                VStack{
                    List{
                        ForEach(hourList, id: \.self){ hour in
                            HStack{
                                Button(action: {
                                    showHourPopUp.toggle()
                                }, label: {
                                    Text(hour[0].formatted(date: .abbreviated, time: .omitted))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                })
                                
                                
                                Spacer()
                                Button(action: {
                                    showHourPopUp.toggle()
                                }, label: {
                                    Text(hour[1], format: .dateTime.hour().minute())
                                        .frame(maxWidth: .infinity, alignment: .center)
                                })
                                Spacer()
                                Button(action: {
                                    showHourPopUp.toggle()
                                }, label: {
                                    Text(hour[2], format: .dateTime.hour().minute())
                                })
                                Spacer()
                                Text("\(numHoursList[hourList.firstIndex(of: hour) ?? -1],specifier: "%0.2f")")
                                    .padding(.leading,10)
                            }
                            
                        }
                        
                        .listRowBackground(Color("Background"))
                        
                    }
                    .labelsHidden()
                    .listStyle(PlainListStyle())
                    Spacer()
                }
                Spacer()
                
                
                
                Text("Total Hours: \(totalHrs, specifier: "%.2f")")
                    .foregroundColor(Color("TextColor"))
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .padding([.bottom,.trailing],40)
                    .bold()
            }
            
            HourPopupScreen(showHourPopUp: $showHourPopUp,
                            selectedDate: $selectedDate,
                            selectedStart: $selectedStart,
                            selectedEnd: $selectedEnd,
                            selectionStep: $selectionStep,
                            hourList: $hourList,
                            numHourList: $numHoursList)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(x:0,y: showHourPopUp ? 0: UIScreen.main.bounds.height)
            
            if(showRateInput){
                RateInputScreen(showRateInput: $showRateInput, rate: $rate)
                    .transition(.move(edge: .bottom))
            }
            
            Spacer()
            
            
          
        }
    }
}


struct HourPopupScreen: View{
    @Environment (\.presentationMode) var presentationMode
    @Binding var showHourPopUp: Bool
    @Binding var selectedDate: Date
    @Binding var selectedStart: Date
    @Binding var selectedEnd: Date
    @Binding var selectionStep: Int
    @Binding var hourList: [[Date]]
    
    let pickDate: Int = 0
    let pickStart: Int = 1
    let pickEnd: Int = 2
    
    
    
    @State var hours:[Date] = []
    @Binding var numHourList:[Double]
    
    var body: some View{
        var num_hours: Double = selectedEnd.timeIntervalSince(selectedStart)/3600
        VStack{
            Rectangle()
                .fill(Color.white)
                .frame(maxWidth: .infinity,minHeight: 300, maxHeight: 300)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.5), radius: 15)
                .padding([.leading,.trailing],15)
                .overlay{
                    VStack{
                        if selectionStep == pickStart{
                            Text("Select start time ")
                                .font(.headline)
                                .foregroundColor(Color.black)
                            DatePicker("", selection: $selectedStart,displayedComponents: [.hourAndMinute])
                                .datePickerStyle(.wheel)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .labelsHidden()
                            
                            
                            
                        }else if selectionStep == pickEnd{
                            Text("Select end time")
                                .font(.headline)
                                .foregroundColor(Color.black)
                            
                            DatePicker("", selection: $selectedEnd,displayedComponents: [.hourAndMinute])
                                .datePickerStyle(.wheel)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .labelsHidden()
                            
                        }else{
                            Text("Select a date")
                                .font(.headline)
                                .foregroundColor(Color.black)
                            
                            DatePicker("", selection: $selectedDate,displayedComponents: [.date])
                                .datePickerStyle(.wheel)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .labelsHidden()
                        }
                    }
                }
            
            Rectangle()
                .fill(Color.blue)
                .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 50)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.5), radius: 15)
                .padding([.leading,.trailing],15)
                .overlay{
                    Button(action: {
                        if selectionStep == 0{
                            hours.append(selectedDate)
                            selectionStep = 1
                        }else if selectionStep == 1{
                            hours.append(selectedStart)
                            selectionStep = 2
                        }else{
                            hours.append(selectedEnd)
                            if(num_hours < 0){
                                num_hours = num_hours + 24
                            }
                            numHourList.append(num_hours)
                            hourList.append(hours)
                            showHourPopUp = false
                            selectionStep = 0
                            hours = []
                        }
                        
                    }, label: {
                        if selectionStep == pickEnd{
                            Text("Done")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            Text("Next")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    })
                }
            
            Rectangle()
                .fill(Color.white)
                .frame(maxWidth: .infinity,minHeight: 30, maxHeight: 50)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.5), radius: 15)
                .padding([.leading,.trailing],15)
                .overlay{
                    Button(action: {
                        selectionStep = 0
                        num_hours = 0
                        showHourPopUp = false
                    }, label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                }
                
        }
        

    }
}

class NumbersOnly: ObservableObject{
    @Published var value = ""{
        didSet{
            let filtered = value.filter{$0.isNumber}
            if value != filtered{
                value = filtered
            }
        }
    }
}

//MARK: Rate Input Screen
struct RateInputScreen: View{
    @Environment(\.presentationMode) var presentationMode
    @Binding var showRateInput: Bool
    @Binding var rate: Double
    
    @ObservedObject var inputRate = NumbersOnly()
   
    
    @FocusState private var focus: Bool
    
    var body: some View{
        
        Color(.gray)
            .opacity(0.5)
            .ignoresSafeArea()
        
        Spacer()
        ZStack{
            Rectangle()
                .fill(.white)
                .frame(maxWidth: 280, maxHeight: 170)
                .cornerRadius(10)
                .shadow(radius: 10)
            
                .overlay{
                    VStack(spacing: 0,content:{
                        Text("Enter Hourly Rate")
                            .foregroundColor(.black)
                            .padding(.top,20)
                            .bold()
                        
                        TextField("Type rate", text: $inputRate.value)
                            .padding(10)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2).cornerRadius(10))
                            .padding(15)
                            .padding(.bottom,-15)
                            .focused($focus)
                            .submitLabel(.done)
                            .onSubmit {
                                rate = (inputRate.value as NSString).doubleValue
                                showRateInput = false
                            }
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: 280,maxHeight: 0.5)
                            .padding(.top,25)
                        
                        HStack(spacing: 0, content: {
                            // cancel to go back
                            Button(action:{
                                showRateInput = false
                            }, label: {
                                Rectangle()
                                    .fill(.white)
                                    .frame(maxWidth: 140,maxHeight: 50)
                                    .cornerRadius(10)
                                    .overlay{
                                        Text("Cancel")
                                            .foregroundColor(.gray)
                                            .bold()
                                    }
                            })
                            
                            Rectangle()
                                .fill(.gray)
                                .frame(maxWidth: 0.2,maxHeight: 50)
                            
                            
                            Button(action: {
                                rate = (inputRate.value as NSString).doubleValue
                                showRateInput = false
                            }, label: {
                                Rectangle()
                                    .fill(.white)
                                    .frame(maxWidth: 140,maxHeight: 50)
                                    .cornerRadius(10)
                                    .overlay{
                                        Text("Enter")
                                            .bold()
                                            .foregroundColor(.blue)
                                    }
                            })
                            
                        })
                    })
                }
        }
        .onAppear{
            focus = true
        }
        
        Spacer()
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            //HoursScreen()
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
        
    }
}
