
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



pub fun serialazeStringArray(_ lines: [String]): String {
    var buffer = ""

    for line in lines {
        buffer = buffer.concat(line)
    }

    return buffer
}

  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      // The following pixels
      // 123
      // 456
      // 789
      // should be serialized as
      // 123456789
      self.pixels = pixels
    }
  }

  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {

    pub let width: UInt8
    pub let height: UInt8
    pub let prints: {String: Canvas}

    init(width: UInt8, height: UInt8) {
      self.width = width;
      self.height = height;
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {
      // Canvas needs to fit Printer's dimensions.
      if canvas.pixels.length != Int(self.width * self.height) {
        return nil
      }

      // Canvas can only use visible ASCII characters.
      for symbol in canvas.pixels.utf8 {
        if symbol < 32 || symbol > 126 {
          return nil
        }
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(canvas.pixels) == false {
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas
        display(canvas: canvas)
        return <- picture
      } else {
        return nil
      }
    }
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

    let printX <- create Printer(width: 5, height: 5)
    let printO <- printX.print(canvas: canvasX)

    destroy letterX
    destroy printX
    destroy printO
}