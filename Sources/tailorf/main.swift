 import Foundation
 import SwiftyBeaver
 
 let log = SwiftyBeaver.self
 func setupSwiftyBeaver(){
    let console = ConsoleDestination()  // log to Xcode Console
    let file = FileDestination()
    file.logFileURL =  URL(string:"file:///Users/wassim/Desktop/Personal/tailorf/logs/tailof.log" )
    let cloud = SBPlatformDestination(appID: "foo", appSecret: "bar", encryptionKey: "123")
    // use custom format and set console output to short time, log level & message
    console.format = "$DHH:mm:ss$d $L $M"
    
    log.addDestination(console)
    log.addDestination(file)
    log.addDestination(cloud)
 }

 setupSwiftyBeaver()
 let data : Foundation.Data!
 #if DEBUG
    print("DEBUG MODE")
 guard let url = Bundle.main.url(forResource: "test", withExtension: "json") else {
    exit(1)
 }
 guard let dataFromFile = NSData(contentsOf: url) else {
    exit(1)
 }
 data = dataFromFile as Foundation.Data
    
 #else
    print("RELASE MODE")
    /// Gets a hand of the standard input
 let stdin = FileHandle.standardInput
    /// This will hault the program until it gets it's input
 data  = stdin.readDataToEndOfFile()
 #endif
 
 let jsonFormatter = JSONFormatter(withData: data as Foundation.Data)
 
 log.verbose("Started parsing summary")
 let summary = jsonFormatter?.parseSummary()
 if summary == nil {
    log.error("Summary is nil")
    fatalError()
 }
 
 let files = jsonFormatter?.parseFiles()
 if files == nil {
    log.error("Files is nil")
    exit(1)
 }
 print("files count : \(files!.count)")

 let reportHandler = ReportHandler(withFiles: files!, andReportSummary: summary!)
