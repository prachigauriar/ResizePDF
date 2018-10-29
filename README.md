# resizepdf

`resizepdf` is a tool for macOS that resizes PDFs! It’s written in Swift and is very simple. It has
no external dependencies.


## Installation

To install `resizepdf`, just pull down the source and run

    xcodebuild install DSTROOT=/


This installs the tool in `/usr/local/bin`. You can further change the installation directory using
a combination of the `DSTROOT` and `INSTALL_PATH`. For example, `DSTROOT=$HOME` and
`INSTALL_PATH=opt/local/bin` would install the binary in `~/opt/local/bin`. Knock yourself out.


## Usage

Just invoke `resizepdf` with the input PDF path, output PDF path, width, and height.

    resizepdf inputPDF outputPDF width height


## License

All code is licensed under the MIT license. Do with it as you will.
