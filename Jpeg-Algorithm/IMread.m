% Read a grayscale picture and generate the coded JPEG stream
% Based on the Baseline algorithm
% The input picture should be 512*512
% Also calculate the compression ratio

clear;
clc;

% Import the Luminance quantization table
LQT = LQTable();       

% Read a .bmp file
[filename, pathname] = uigetfile( ...
{ '*.bmp','BMP-files (*.bmp)';...
  '*.pgm','PGM-files (*.pgm)';...
  '*.*','All Files (*.*)' }, ...
  'Select Original Picture');
orignPic = double(imread([pathname filename]));
disp('Read Complete!');

[M,N] = size(orignPic);
lastDC = 0;
codedStream = '';

% 8*8 bit wise coding
for i = 0:M/8-1
    for j = 0:N/8-1
        % get a 8*8 submatrix
        subM = orignPic((1+8*i):(8*(i+1)), (1+8*j):(8*(j+1)));
        % do DCT to the submatrix
        subM = DCT_8(subM);
        % quantization procedure
        subM = round(subM./LQT);
        % Create a Zig_Zag list
        zList = Zig_Zag (subM);
        codedDC = DC_Huffman( zList(1), lastDC );
        lastDC = zList(1);
        codedAC = AC_Huffman( zList(2:64));
        % the coded stream for picture information
        codedStream = [codedStream codedDC codedAC];
    end
end

% Start of Image marker: FFD8 = 255 216
SOI = [255 216];

% End of Image marker: FFD9 = 255 217
EOI = [255 217];

% Define Quantization Table marker (lum): FFDB = 255 219
% Length: two bytes that indicate the number of bytes = 000 067
% Precision = 000 (baseline)
tempT = Zig_Zag (LQTable());
DQT = [255 219 000 067 000 tempT ];

% Start of frame marker: FFC0=255 192 (baseline)
SOF = [255 192];

% Define Huffman Table marker (DC): FFC4 = 255 196
% Length: two bytes that indicate the number of bytes = 000 031
% Table class = 000 (DC table)
% Number of Huffman codes (16 bytes) =  000	001	005	001	001	001	001	001	001	000	000	000	000	000	000	000
% HUFFVAL next
DHT_DC = [  255 196 000 031 000 ...
            000	001	005	001	001	001	001	001	001	000	000	000	000	000	000	000 ...
            000	001	002	003	004	005	006	007 008	009	010	011];
        
% Define Huffman Table marker (AC): FFC4 = 255 196
% Length: two bytes that indicate the number of bytes = 000 181
% Table class = 001 (AC table)
% Number of Huffman codes (16 bytes) =  000	002	001	003	003	002	004	003	005 005	004	004	000	000	001	125
% HUFFVAL next
DHT_AC = [  255 196 000 181 001 ...
            000	002	001	003	003	002	004	003	005 005	004	004	000	000	001	125 ...
            001	002	003	000	004	017	005	018	033	049	065	006	019	081	097	007	...
            034	113	020	050	129	145	161	008	035	066	177	193	021	082	209	240	...
            036	051	098	114	130	009	010	022	023	024	025	026	037	038	039	040	...
            041	042	052	053	054	055	056	057	058	067	068	069	070	071	072	073	...
            074	083	084	085	086	087	088	089	090	099	100	101	102	103	104	105	...
            106	115	116	117	118	119	120	121	122	131	132	133	134	135	136	137	...
            138	146	147	148	149	150	151	152	153	154	162	163	164	165	166	167	...
            168	169	170 178	179	180	181	182	183	184	185	186	194	195	196	197	...
            198	199	200	201	202	210	211 212	213	214	215	216	217	218	225	226	...
            227	228	229	230	231	232	233	234	241	242	243	244	245	246	247	248	...
            249	250 ];

% final compressed JPEG stream
% Necessay side information is added
% Note that not all information is appended, cause they are not used at the
%      decoding side.
jpegStream = [Dec2Bin(SOI) Dec2Bin(DQT) Dec2Bin(DHT_DC) Dec2Bin(DHT_AC) ...
              Dec2Bin(SOF) codedStream Dec2Bin(EOI)];

fw = fopen('JpegStream.txt','w');
fprintf(fw, '%s\n', jpegStream);
fclose(fw);

display ('The Compressed JPEG is (bits):');
disp (length(jpegStream));

rate = 8*M*N/length(jpegStream);
display (rate);



