// Copyright 2011 Google Inc. All Rights Reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the COPYING file in the root of the source
// tree. An additional intellectual property rights grant can be found
// in the file PATENTS. All contributing project authors may
// be found in the AUTHORS file in the root of the source tree.
// -----------------------------------------------------------------------------
//
//   WebP encoder: main interface
//
// Author: Skal (pascal.massimino@gmail.com)

using System;
using System.Interop;

namespace libwebp;

extension libwebp
{
	const c_int WEBP_ENCODER_ABI_VERSION = 0x0210; // MAJOR(8b) + MINOR(8b)

	// Return the encoder's version number, packed in hexadecimal using 8bits for
	// each of major/minor/revision. E.g: v2.5.7 is 0x020507.
	[CLink] public static extern c_int WebPGetEncoderVersion();

	//------------------------------------------------------------------------------
	// One-stop-shop call! No questions asked:

	// Returns the size of the compressed data (pointed to by *output), or 0 if
	// an error occurred. The compressed data must be released by the caller
	// using the call 'WebPFree(*output)'.
	// These functions compress using the lossy format, and the quality_factor
	// can go from 0 (smaller output, lower quality) to 100 (best quality,
	// larger output).
	[CLink] public static extern size_t WebPEncodeRGB(uint8_t* rgb, c_int width, c_int height, c_int stride, float quality_factor, uint8_t** output);
	[CLink] public static extern size_t WebPEncodeBGR(uint8_t* bgr, c_int width, c_int height, c_int stride, float quality_factor, uint8_t** output);
	[CLink] public static extern size_t WebPEncodeRGBA(uint8_t* rgba, c_int width, c_int height, c_int stride, float quality_factor, uint8_t** output);
	[CLink] public static extern size_t WebPEncodeBGRA(uint8_t* bgra, c_int width, c_int height, c_int stride, float quality_factor, uint8_t** output);

	// These functions are the equivalent of the above, but compressing in a
	// lossless manner. Files are usually larger than lossy format, but will
	// not suffer any compression loss.
	// Note these functions, like the lossy versions, use the library's default
	// settings. For lossless this means 'exact' is disabled. RGB values in
	// transparent areas will be modified to improve compression. To avoid this,
	// use WebPEncode() and set WebPConfig::exact to 1.
	[CLink] public static extern size_t WebPEncodeLosslessRGB(uint8_t* rgb, c_int width, c_int height, c_int stride, uint8_t** output);
	[CLink] public static extern size_t WebPEncodeLosslessBGR(uint8_t* bgr, c_int width, c_int height, c_int stride, uint8_t** output);
	[CLink] public static extern size_t WebPEncodeLosslessRGBA(uint8_t* rgba, c_int width, c_int height, c_int stride, uint8_t** output);
	[CLink] public static extern size_t WebPEncodeLosslessBGRA(uint8_t* bgra, c_int width, c_int height, c_int stride, uint8_t** output);

	//------------------------------------------------------------------------------
	// Coding parameters

	// Image characteristics hint for the underlying encoder.
	public enum WebPImageHint : c_int
	{
		WEBP_HINT_DEFAULT = 0, // default preset.
		WEBP_HINT_PICTURE, // digital picture, like portrait, inner shot
		WEBP_HINT_PHOTO, // outdoor photograph, with natural lighting
		WEBP_HINT_GRAPH, // Discrete tone image (graph, map-tile etc).
		WEBP_HINT_LAST
	}

	// Compression parameters.
	struct WebPConfig
	{
		c_int lossless; // Lossless encoding (0=lossy(default), 1=lossless).
		float quality; // between 0 and 100. For lossy, 0 gives the smallest
								// size and 100 the largest. For lossless, this
								// parameter is the amount of effort put into the
								// compression: 0 is the fastest but gives larger
								// files compared to the slowest, but best, 100.
		c_int method; // quality/speed trade-off (0=fast, 6=slower-better)

		WebPImageHint image_hint; // Hint for image type (lossless only for now).

		c_int target_size; // if non-zero, set the desired target size in bytes.
								// Takes precedence over the 'compression' parameter.
		float target_PSNR; // if non-zero, specifies the minimal distortion to
								// try to achieve. Takes precedence over target_size.
		c_int segments; // maximum number of segments to use, in [1..4]
		c_int sns_strength; // Spatial Noise Shaping. 0=off, 100=maximum.
		c_int filter_strength; // range: [0 = off .. 100 = strongest]
		c_int filter_sharpness; // range: [0 = off .. 7 = least sharp]
		c_int filter_type; // filtering type: 0 = simple, 1 = strong (only used
								// if filter_strength > 0 or autofilter > 0)
		c_int autofilter; // Auto adjust filter's strength [0 = off, 1 = on]
		c_int alpha_compression; // Algorithm for encoding the alpha plane (0 = none,
								// 1 = compressed with WebP lossless). Default is 1.
		c_int alpha_filtering; // Predictive filtering method for alpha plane.
								//  0: none, 1: fast, 2: best. Default if 1.
		c_int alpha_quality; // Between 0 (smallest size) and 100 (lossless).
								// Default is 100.
		c_int pass; // number of entropy-analysis passes (in [1..10]).

		c_int show_compressed; // if true, export the compressed picture back.
								// In-loop filtering is not applied.
		c_int preprocessing; // preprocessing filter:
								// 0=none, 1=segment-smooth, 2=pseudo-random dithering
		c_int partitions; // log2(number of token partitions) in [0..3]. Default
								// is set to 0 for easier progressive decoding.
		c_int partition_limit; // quality degradation allowed to fit the 512k limit
								// on prediction modes coding (0: no degradation,
								// 100: maximum possible degradation).
		c_int emulate_jpeg_size; // If true, compression parameters will be remapped
								// to better match the expected output size from
								// JPEG compression. Generally, the output size will
								// be similar but the degradation will be lower.
		c_int thread_level; // If non-zero, try and use multi-threaded encoding.
		c_int low_memory; // If set, reduce memory usage (but increase CPU use).

		c_int near_lossless; // Near lossless encoding [0 = max loss .. 100 = off
								// (default)].
		c_int exact; // if non-zero, preserve the exact RGB values under
								// transparent area. Otherwise, discard this invisible
								// RGB information for better compression. The default
								// value is 0.

		c_int use_delta_palette; // reserved
		c_int use_sharp_yuv; // if needed, use sharp (and slow) RGB->YUV conversion

		c_int qmin; // minimum permissible quality factor
		c_int qmax; // maximum permissible quality factor
	}

	// Enumerate some predefined settings for WebPConfig, depending on the type
	// of source picture. These presets are used when calling WebPConfigPreset().
	public enum WebPPreset : c_int
	{
		WEBP_PRESET_DEFAULT = 0, // default preset.
		WEBP_PRESET_PICTURE, // digital picture, like portrait, inner shot
		WEBP_PRESET_PHOTO, // outdoor photograph, with natural lighting
		WEBP_PRESET_DRAWING, // hand or line drawing, with high-contrast details
		WEBP_PRESET_ICON, // small-sized colorful images
		WEBP_PRESET_TEXT // text-like
	}

	// Internal, version-checked, entry point
	[CLink] public static extern c_int WebPConfigInitInternal(WebPConfig*, WebPPreset, float, c_int);

	// Should always be called, to initialize a fresh WebPConfig structure before
	// modification. Returns false in case of version mismatch. WebPConfigInit()
	// must have succeeded before using the 'config' object.
	// Note that the default values are lossless=0 and quality=75.
	/*static WEBP_INLINE c_int WebPConfigInit(WebPConfig* config)
	{
		return WebPConfigInitInternal(config, WEBP_PRESET_DEFAULT, 75.f, WEBP_ENCODER_ABI_VERSION);
	}*/

	// This function will initialize the configuration according to a predefined
	// set of parameters (referred to by 'preset') and a given quality factor.
	// This function can be called as a replacement to WebPConfigInit(). Will
	// return false in case of error.
	/*static WEBP_INLINE c_int WebPConfigPreset(WebPConfig* config, WebPPreset preset, float quality)
	{
		return WebPConfigInitInternal(config, preset, quality, WEBP_ENCODER_ABI_VERSION);
	}*/

	// Activate the lossless compression mode with the desired efficiency level
	// between 0 (fastest, lowest compression) and 9 (slower, best compression).
	// A good default level is '6', providing a fair tradeoff between compression
	// speed and final compressed size.
	// This function will overwrite several fields from config: 'method', 'quality'
	// and 'lossless'. Returns false in case of parameter error.
	[CLink] public static extern c_int WebPConfigLosslessPreset(WebPConfig* config,  c_int level);

	// Returns true if 'config' is non-NULL and all configuration parameters are
	// within their valid ranges.
	[CLink] public static extern c_int WebPValidateConfig(WebPConfig* config);

	//------------------------------------------------------------------------------
	// Input / Output
	// Structure for storing auxiliary statistics.

	struct WebPAuxStats
	{
		c_int coded_size; // final size

		float[5] PSNR; // peak-signal-to-noise ratio for Y/U/V/All/Alpha
		c_int[3] block_count; // number of intra4/intra16/skipped macroblocks
		c_int[2] header_bytes; // approximate number of bytes spent for header
								// and mode-partition #0
		c_int[3][4] residual_bytes; // approximate number of bytes spent for
		  // DC/AC/uv coefficients for each (0..3) segments.
		c_int[4] segment_size; // number of macroblocks in each segments
		c_int[4] segment_quant; // quantizer values for each segments
		c_int[4] segment_level; // filtering strength for each segments [0..63]

		c_int alpha_data_size; // size of the transparency data
		c_int layer_data_size; // size of the enhancement layer data

		// lossless encoder statistics
		uint32_t lossless_features; // bit0:predictor bit1:cross-color transform
									// bit2:subtract-green bit3:color indexing
		c_int histogram_bits; // number of precision bits of histogram
		c_int transform_bits; // precision bits for predictor transform
		c_int cache_bits; // number of bits for color cache lookup
		c_int palette_size; // number of color in palette, if used
		c_int lossless_size; // final lossless size
		c_int lossless_hdr_size; // lossless header (transform, huffman etc) size
		c_int lossless_data_size; // lossless image data size
		c_int cross_color_transform_bits; // precision bits for cross-color transform

		uint32_t[1] pad; // padding for later use
	}

	// Signature for output function. Should return true if writing was successful.
	// data/data_size is the segment of data to write, and 'picture' is for
	// reference (and so one can make use of picture->custom_ptr).
	public function c_int WebPWriterFunction(uint8_t* data, size_t data_size, WebPPicture* picture);

	// WebPMemoryWrite: a special WebPWriterFunction that writes to memory using
	// the following WebPMemoryWriter object (to be set as a custom_ptr).
	struct WebPMemoryWriter
	{
		uint8_t* mem; // final buffer (of size 'max_size', larger than 'size').
		size_t   size; // final size
		size_t   max_size; // total capacity
		uint32_t[1] pad; // padding for later use
	}

	// The following must be called first before any use.
	[CLink] public static extern void WebPMemoryWriterInit(WebPMemoryWriter* writer);

	// The following must be called to deallocate writer->mem memory. The 'writer'
	// object itself is not deallocated.
	[CLink] public static extern void WebPMemoryWriterClear(WebPMemoryWriter* writer);

	// The custom writer to be used with WebPMemoryWriter as custom_ptr. Upon
	// completion, writer.mem and writer.size will hold the coded data.
	// writer.mem must be freed by calling WebPMemoryWriterClear.
	[CLink] public static extern c_int WebPMemoryWrite(uint8_t* data, size_t data_size, WebPPicture* picture);

	// Progress hook, called from time to time to report progress. It can return
	// false to request an abort of the encoding process, or true otherwise if
	// everything is OK.
	public function c_int WebPProgressHook(c_int percent, WebPPicture* picture);

	// Color spaces.
	[AllowDuplicates]
	public enum WebPEncCSP : c_int
	{
		// chroma sampling
		WEBP_YUV420  = 0, // 4:2:0
		WEBP_YUV420A = 4, // alpha channel variant
		WEBP_CSP_UV_MASK = 3, // bit-mask to get the UV sampling factors
		WEBP_CSP_ALPHA_BIT = 4 // bit that is set if alpha is present
	}

// Encoding error conditions.
	public enum WebPEncodingError : c_int
	{
		VP8_ENC_OK = 0,
		VP8_ENC_ERROR_OUT_OF_MEMORY, // memory error allocating objects
		VP8_ENC_ERROR_BITSTREAM_OUT_OF_MEMORY, // memory error while flushing bits
		VP8_ENC_ERROR_NULL_PARAMETER, // a pointer parameter is NULL
		VP8_ENC_ERROR_INVALID_CONFIGURATION, // configuration is invalid
		VP8_ENC_ERROR_BAD_DIMENSION, // picture has invalid width/height
		VP8_ENC_ERROR_PARTITION0_OVERFLOW, // partition is bigger than 512k
		VP8_ENC_ERROR_PARTITION_OVERFLOW, // partition is bigger than 16M
		VP8_ENC_ERROR_BAD_WRITE, // error while flushing bytes
		VP8_ENC_ERROR_FILE_TOO_BIG, // file is bigger than 4G
		VP8_ENC_ERROR_USER_ABORT, // abort request by user
		VP8_ENC_ERROR_LAST // list terminator. always last.
	}

// maximum width/height allowed (inclusive), in pixels
	const c_int WEBP_MAX_DIMENSION = 16383;

// Main exchange structure (input samples, output bytes, statistics)
	  //
// Once WebPPictureInit() has been called, it's ok to make all the INPUT fields
// (use_argb, y/u/v, argb, ...) point to user-owned data, even if
// WebPPictureAlloc() has been called. Depending on the value use_argb,
// it's guaranteed that either *argb or *y/*u/*v content will be kept untouched.
	[CRepr]
	public struct WebPPicture
	{
		//   INPUT
		//////////////
		// Main flag for encoder selecting between ARGB or YUV input.
		// It is recommended to use ARGB input (*argb, argb_stride) for lossless
		// compression, and YUV input (*y, *u, *v, etc.) for lossy compression
		// since these are the respective native colorspace for these formats.
		c_int use_argb;

		// YUV input (mostly used for input to lossy compression)
		WebPEncCSP colorspace; // colorspace: should be YUV420 for now (=Y'CbCr).
		c_int width, height; // dimensions (less or equal to WEBP_MAX_DIMENSION)
		uint8_t* y;
		uint8_t* u;
		uint8_t* v; // pointers to luma/chroma planes.
		c_int y_stride, uv_stride; // luma/chroma strides.
		uint8_t* a; // pointer to the alpha plane
		c_int a_stride; // stride of the alpha plane
		uint32_t[2] pad1; // padding for later use

		// ARGB input (mostly used for input to lossless compression)
		uint32_t* argb; // Pointer to argb (32 bit) plane.
		c_int argb_stride; // This is stride in pixels units, not bytes.
		uint32_t[3] pad2; // padding for later use

		//   OUTPUT
		///////////////
		// Byte-emission hook, to store compressed bytes as they are ready.
		WebPWriterFunction writer; // can be NULL
		void* custom_ptr; // can be used by the writer.

		// map for extra information (only for lossy compression mode)
		c_int extra_info_type; // 1: intra type, 2: segment, 3: quant
								// 4: intra-16 prediction mode,
								// 5: chroma prediction mode,
								// 6: bit cost, 7: distortion
		uint8_t* extra_info; // if not NULL, points to an array of size
								// ((width + 15) / 16) * ((height + 15) / 16) that
								// will be filled with a macroblock map, depending
								// on extra_info_type.

		//   STATS AND REPORTS
		///////////////////////////
		// Pointer to side statistics (updated only if not NULL)
		WebPAuxStats* stats;

		// Error code for the latest error encountered during encoding
		WebPEncodingError error_code;

		// If not NULL, report progress during encoding.
		WebPProgressHook progress_hook;

		void* user_data; // this field is free to be set to any value and
								// used during callbacks (like progress-report e.g.).

		uint32_t[3] pad3; // padding for later use

		// Unused for now
		uint8_t* pad4;
		uint8_t* pad5;
		uint32_t[8] pad6; // padding for later use

		// PRIVATE FIELDS
		////////////////////
		void* memory_; // row chunk of memory for yuva planes
		void* memory_argb_; // and for argb too.
		void*[2] pad7; // padding for later use
	}

	// Internal, version-checked, entry point
	[CLink] public static extern c_int WebPPictureInitInternal(WebPPicture*, c_int);

	// Should always be called, to initialize the structure. Returns false in case
	// of version mismatch. WebPPictureInit() must have succeeded before using the
	// 'picture' object.
	// Note that, by default, use_argb is false and colorspace is WEBP_YUV420.
	// static WEBP_INLINE c_int WebPPictureInit(WebPPicture* picture) {
	//   return WebPPictureInitInternal(picture, WEBP_ENCODER_ABI_VERSION);
	// }
	
		  //------------------------------------------------------------------------------
	// WebPPicture utils

	// Convenience allocation / deallocation based on picture->width/height:
	// Allocate y/u/v buffers as per colorspace/width/height specification.
	// Note! This function will free the previous buffer if needed.
	// Returns false in case of memory error.
	[CLink] public static extern c_int WebPPictureAlloc(WebPPicture* picture);

	// Release the memory allocated by WebPPictureAlloc() or WebPPictureImport*().
	// Note that this function does _not_ free the memory used by the 'picture'
	// object itself.
	// Besides memory (which is reclaimed) all other fields of 'picture' are
	// preserved.
	[CLink] public static extern void WebPPictureFree(WebPPicture* picture);

	// Copy the pixels of *src into *dst, using WebPPictureAlloc. Upon return, *dst
	// will fully own the copied pixels (this is not a view). The 'dst' picture need
	// not be initialized as its content is overwritten.
	// Returns false in case of memory allocation error.
	[CLink] public static extern c_int WebPPictureCopy(WebPPicture* src, WebPPicture* dst);

	// Compute the single distortion for packed planes of samples.
	// 'src' will be compared to 'ref', and the raw distortion stored into
	// '*distortion'. The refined metric (log(MSE), log(1 - ssim),...' will be
	// stored in '*result'.
	// 'x_step' is the horizontal stride (in bytes) between samples.
	// 'src/ref_stride' is the byte distance between rows.
	// Returns false in case of error (bad parameter, memory allocation error, ...).
	[CLink] public static extern c_int WebPPlaneDistortion(uint8_t* src, size_t src_stride, uint8_t* ref_, size_t ref_stride, c_int width, c_int height, size_t x_step, c_int type, /* 0 = PSNR, 1 = SSIM, 2 = LSIM */ float* distortion, float* result);

	// Compute PSNR, SSIM or LSIM distortion metric between two pictures. Results
	// are in dB, stored in result[] in the B/G/R/A/All order. The distortion is
	// always performed using ARGB samples. Hence if the input is YUV(A), the
	// picture will be internally converted to ARGB (just for the measurement).
	// Warning: this function is rather CPU-intensive.
	[CLink] public static extern c_int WebPPictureDistortion(WebPPicture* src, WebPPicture* ref_, c_int metric_type, /* 0 = PSNR, 1 = SSIM, 2 = LSIM */ float[5] result);

	// self-crops a picture to the rectangle defined by top/left/width/height.
	// Returns false in case of memory allocation error, or if the rectangle is
	// outside of the source picture.
	// The rectangle for the view is defined by the top-left corner pixel
	// coordinates (left, top) as well as its width and height. This rectangle
	// must be fully be comprised inside the 'src' source picture. If the source
	// picture uses the YUV420 colorspace, the top and left coordinates will be
	// snapped to even values.
	[CLink] public static extern c_int WebPPictureCrop(WebPPicture* picture, c_int left, c_int top, c_int width, c_int height);

	// Extracts a view from 'src' picture into 'dst'. The rectangle for the view
	// is defined by the top-left corner pixel coordinates (left, top) as well
	// as its width and height. This rectangle must be fully be comprised inside
	// the 'src' source picture. If the source picture uses the YUV420 colorspace,
	// the top and left coordinates will be snapped to even values.
	// Picture 'src' must out-live 'dst' picture. Self-extraction of view is allowed
	// ('src' equal to 'dst') as a mean of fast-cropping (but note that doing so,
	// the original dimension will be lost). Picture 'dst' need not be initialized
	// with WebPPictureInit() if it is different from 'src', since its content will
	// be overwritten.
	// Returns false in case of invalid parameters.
	[CLink] public static extern c_int WebPPictureView(WebPPicture* src, c_int left, c_int top, c_int width, c_int height, WebPPicture* dst);

	// Returns true if the 'picture' is actually a view and therefore does
	// not own the memory for pixels.
	[CLink] public static extern c_int WebPPictureIsView(WebPPicture* picture);

	// Rescale a picture to new dimension width x height.
	// If either 'width' or 'height' (but not both) is 0 the corresponding
	// dimension will be calculated preserving the aspect ratio.
	// No gamma correction is applied.
	// Returns false in case of error (invalid parameter or insufficient memory).
	[CLink] public static extern c_int WebPPictureRescale(WebPPicture* picture, c_int width, c_int height);

	// Colorspace conversion function to import RGB samples.
	// Previous buffer will be free'd, if any.
	// *rgb buffer should have a size of at least height * rgb_stride.
	// Returns false in case of memory error.
	[CLink] public static extern c_int WebPPictureImportRGB(WebPPicture* picture, uint8_t* rgb, c_int rgb_stride);

	// Same, but for RGBA buffer.
	[CLink] public static extern c_int WebPPictureImportRGBA(WebPPicture* picture, uint8_t* rgba, c_int rgba_stride);

	// Same, but for RGBA buffer. Imports the RGB direct from the 32-bit format
	// input buffer ignoring the alpha channel. Avoids needing to copy the data
	// to a temporary 24-bit RGB buffer to import the RGB only.
	[CLink] public static extern c_int WebPPictureImportRGBX(WebPPicture* picture, uint8_t* rgbx, c_int rgbx_stride);

	// Variants of the above, but taking BGR(A|X) input.
	[CLink] public static extern c_int WebPPictureImportBGR(WebPPicture* picture, uint8_t* bgr, c_int bgr_stride);
	[CLink] public static extern c_int WebPPictureImportBGRA(WebPPicture* picture, uint8_t* bgra, c_int bgra_stride);
	[CLink] public static extern c_int WebPPictureImportBGRX(WebPPicture* picture, uint8_t* bgrx, c_int bgrx_stride);

	// Converts picture->argb data to the YUV420A format. The 'colorspace'
	// parameter is deprecated and should be equal to WEBP_YUV420.
	// Upon return, picture->use_argb is set to false. The presence of real
	// non-opaque transparent values is detected, and 'colorspace' will be
	// adjusted accordingly. Note that this method is lossy.
	// Returns false in case of error.
	[CLink] public static extern c_int WebPPictureARGBToYUVA(WebPPicture* picture, WebPEncCSP /*colorspace = WEBP_YUV420*/);

	// Same as WebPPictureARGBToYUVA(), but the conversion is done using
	// pseudo-random dithering with a strength 'dithering' between
	// 0.0 (no dithering) and 1.0 (maximum dithering). This is useful
	// for photographic picture.
	[CLink] public static extern c_int WebPPictureARGBToYUVADithered(WebPPicture* picture, WebPEncCSP colorspace, float dithering);

	// Performs 'sharp' RGBA->YUVA420 downsampling and colorspace conversion
	// Downsampling is handled with extra care in case of color clipping. This
	// method is roughly 2x slower than WebPPictureARGBToYUVA() but produces better
	// and sharper YUV representation.
	// Returns false in case of error.
	[CLink] public static extern c_int WebPPictureSharpARGBToYUVA(WebPPicture* picture);
	// kept for backward compatibility:
	[CLink] public static extern c_int WebPPictureSmartARGBToYUVA(WebPPicture* picture);

	// Converts picture->yuv to picture->argb and sets picture->use_argb to true.
	// The input format must be YUV_420 or YUV_420A. The conversion from YUV420 to
	// ARGB incurs a small loss too.
	// Note that the use of this colorspace is discouraged if one has access to the
	// raw ARGB samples, since using YUV420 is comparatively lossy.
	// Returns false in case of error.
	[CLink] public static extern c_int WebPPictureYUVAToARGB(WebPPicture* picture);

	// Helper function: given a width x height plane of RGBA or YUV(A) samples
	// clean-up or smoothen the YUV or RGB samples under fully transparent area,
	// to help compressibility (no guarantee, though).
	[CLink] public static extern void WebPCleanupTransparentArea(WebPPicture* picture);

	// Scan the picture 'picture' for the presence of non fully opaque alpha values.
	// Returns true in such case. Otherwise returns false (indicating that the
	// alpha plane can be ignored altogether e.g.).
	[CLink] public static extern c_int WebPPictureHasTransparency(WebPPicture* picture);

	// Remove the transparency information (if present) by blending the color with
	// the background color 'background_rgb' (specified as 24bit RGB triplet).
	// After this call, all alpha values are reset to 0xff.
	[CLink] public static extern void WebPBlendAlpha(WebPPicture* picture, uint32_t background_rgb);

	//------------------------------------------------------------------------------
	// Main call
	
	// Main encoding call, after config and picture have been initialized.
	// 'picture' must be less than 16384x16384 in dimension (cf WEBP_MAX_DIMENSION),
	// and the 'config' object must be a valid one.
	// Returns false in case of error, true otherwise.
	// In case of error, picture->error_code is updated accordingly.
	// 'picture' can hold the source samples in both YUV(A) or ARGB input, depending
	// on the value of 'picture->use_argb'. It is highly recommended to use
	// the former for lossy encoding, and the latter for lossless encoding
	// (when config.lossless is true). Automatic conversion from one format to
	// another is provided but they both incur some loss.
	[CLink] public static extern c_int WebPEncode(WebPConfig* config, WebPPicture* picture);
}