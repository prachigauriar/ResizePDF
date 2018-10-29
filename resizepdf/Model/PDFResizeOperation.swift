//
//  PDFResizeOperation.swift
//  resizepdf
//
//  Created by Prachi Gauriar on 10/17/2017.
//  Copyright © 2017 Grubhub, Inc. All rights reserved.
//

import Foundation


enum PDFResizeError : Error {
    /// Indicates that the input PDF located at the associated `URL` could not be opened.
    case couldNotOpenFileURL(URL)
    
    /// Indicates that an output PDF could not be created at the associated `URL`.
    case couldNotCreateOutputPDF(URL)
}



/// `PDFResizeOperation` resizes a PDF to a specified output size.
final class PDFResizeOperation : ConcurrentProgressReportingOperation {
    /// The URL for the PDF to resize.
    let inputURL: URL

    /// The URL at which to output the resized PDF.
    let outputURL: URL

    /// The new size for the input PDF.
    let outputSize: CGSize

    /// An error (if any) that may have occurred while resizing the PDF.
    private(set) var error: PDFResizeError?
    
    
    /// Creates a new `PDFResizeOperation`.
    ///
    /// - Parameters:
    ///   - inputURL: The URL of PDF to resize.
    ///   - outputURL: The URL at which to output the resized PDF.
    ///   - outputSize: The new size for the input PDF.
    init(inputURL: URL, outputURL: URL, outputSize: CGSize) {
        self.inputURL = inputURL
        self.outputURL = outputURL
        self.outputSize = outputSize
    }
    
    
    override func start() {
        // If we’re finished or canceled, return immediately
        guard !isFinished && !isCancelled else {
            return
        }
        
        isExecuting = true
        
        // However we exit, we want to mark ourselves as no longer executing
        defer { isFinished = true }
        
        // If we couldn’t open the input PDF, set our error, finish, and exit
        guard let inputPDFDocument = CGPDFDocument(inputURL as CFURL) else {
            error = .couldNotOpenFileURL(inputURL)
            return
        }
        
        // If we couldn’t create the output PDF context, set our error, finish, and exit
        guard let outputPDFContext = CGContext(outputURL as CFURL, mediaBox: nil, nil) else {
            error = .couldNotCreateOutputPDF(outputURL)
            return
        }

        let pageCount = inputPDFDocument.numberOfPages
        progress.totalUnitCount = Int64(pageCount)
        
        let pageSequence = PDFPageSequence(document: inputPDFDocument)
        for page in pageSequence {
            guard !isCancelled else {
                break
            }
            
            // Start a new page in our output, get the contents of the page from our input, write that page to our output
            var mediaBox = page.getBoxRect(.mediaBox)
            outputPDFContext.withGraphicsState {
                mediaBox.size = outputSize
                outputPDFContext.beginPage(mediaBox: &mediaBox)

                // Create a transform that scales X and Y appropriately
                let cropBox = page.getBoxRect(.cropBox)
                let xScale = outputSize.width / cropBox.size.width
                let yScale = outputSize.height / cropBox.size.height
                outputPDFContext.scaleBy(x: xScale, y: yScale)
                
                outputPDFContext.drawPDFPage(page)
                outputPDFContext.endPage()
            }
            
            progress.completedUnitCount += 1            
        }
        
        outputPDFContext.closePDF()
        
        // If we were canceled, try to remove the output PDF, but don’t worry about it if we can’t
        if isCancelled {
            do {
                try FileManager.default.removeItem(at: outputURL)
            } catch {
            }
        }
    }
}


private struct PDFPageSequence : Sequence, IteratorProtocol {
    let document: CGPDFDocument
    private(set) var currentPage: Int = 1

    
    init(document: CGPDFDocument) {
        self.document = document
    }
    
    mutating func next() -> CGPDFPage? {
        defer { currentPage += 1 }
        return document.page(at: currentPage)
    }
}
