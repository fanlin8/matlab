# JPEG Baseline Compression Implementation
The image compression algorithm of JPEG Baseline Standard is implemented in this program. And both the encoding and decoding procedures for a grayscale picture are realized by MATLAB. 

# Program Listing
## `IMread.m` 
The script that do the encoder's work. All basic steps listed above is performed, note that only 512×512 pixels grayscale images are supported. At last this program, the compression ratio of the encoder will be calculated and displayed. Note not all markers are appended in this program for simplicity, only table specifications are added to the coded stream. 
## `JpegRecon.m` 
The inverse process of coding, decoding is implemented in this file. The input bits file must be generated from last script. The program will generate all necessary tables (LQ, DC, AC) at first and then do the decoding work.
## Fuctions
`AC_Huffman.m`: Huffman coding algorithm for AC coefficients. The Run-Length Encoding (RLE) scheme is used.

`AC_SSSS.m`: Return the SSSS number in AC coefficients coding.

`ACTable.m`: Define the table for luminance AC coefficients coding.

`Bin2Dec.m`: Convert in input 8-bit binary string to an array of decimal numbers.

`DC_Huffman.m`: Huffman coding algorithm for DC coefficients. The Differential Pulse Code Modulation (DPCM) is used.

`DCT_8.m`: Do Forward Discrete Cosine Transform (FDCT) for an input 8×8 Matrix, return an 8×8 matrix. The FDCT will concentrate all low frequency part of the image in the left-up corner, and the high frequency part is relocated into the right-down side.

`DCTable.m`: Define the table for luminance DC coefficients.

`Dec2Bin.m`: Convert the input decimal value to an 8-bit binary string.

`HUFFCODE.m`: Generate the Huffman code word according to input HUFFSIZE.

`HUFFSIZE.m`: Generate the Huffman size table according to the input HUFFBITS.

`IDCT_8.m`: Do IDCT for an input 8×8 Matrix.

`LQTable.m`: Define the table for luminance quantization.

`ORDERCODE.m`: Generate the ordered Huffman Table.

`Table_Build.m`: Generate a Huffman code table.

`Zig_Zag.m`: Convert an input 8×8 Matrix to a 1D list in Zig-Zag order. 
