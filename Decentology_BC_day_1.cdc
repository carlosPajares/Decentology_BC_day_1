
pub struct Canvas  {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init (width: UInt8, height: UInt8, pixels: String ) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }
    
}

pub fun display(canvas: Canvas){    
  let frameTopBottomStyle: String = "+-----+"
  let frameSideStyle: String = "|"
  var counter: Int = 0
  let rowCount: Int  = Int(canvas.height)
  let rowWidth: Int  = Int(canvas.width)
  log(frameTopBottomStyle) //header


  while counter <= rowCount-1 { // loop rows
    log(frameSideStyle.concat(canvas.pixels.slice(from: (counter * rowCount), upTo: (counter * rowCount + rowWidth)).concat(frameSideStyle)))
    counter = counter + 1
  } 
  log(frameTopBottomStyle) //footer
}


pub resource Printer {
  pub fun print(canvas: Canvas): @Picture? {
    //log(canvas)
    //Print de canvas with frame
    display(canvas: canvas)

    let mPicture <- create Picture(canvas: canvas)
    return <- mPicture 
  }
}


pub resource Picture {
    pub let canvas: Canvas

    init (canvas: Canvas) {
        self.canvas = canvas
    }
}

pub fun serialazeStringArray(_ lines: [String]): String {
    var buffer = ""

    for line in lines {
        buffer = buffer.concat(line)
    }

    return buffer
}

pub fun main(){
    let pixelsX = [
        "*   *",
        " * * ",
        "  *  ",
        " * * ",
        "*   *"
    ]
    let canvasX = Canvas(
        width: 5,
        height: 5,
        pixels: serialazeStringArray(pixelsX)        
    )

    let letterX <- create Picture(canvas: canvasX)
    log(letterX.canvas)

    let printX <- create Printer()
    let printO <- printX.print(canvas: canvasX)

    destroy letterX
    destroy printX
    destroy printO
}