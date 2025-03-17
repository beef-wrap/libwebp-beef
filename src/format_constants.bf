// Copyright 2012 Google Inc. All Rights Reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the COPYING file in the root of the source
// tree. An additional intellectual property rights grant can be found
// in the file PATENTS. All contributing project authors may
// be found in the AUTHORS file in the root of the source tree.
// -----------------------------------------------------------------------------
//
//  Internal header for constants related to WebP file format.
//
// Author: Urvang (urvang@google.com)

using System;
using System.Interop;

namespace libwebp;

extension libwebp
{

// Create fourcc of the chunk from the chunk tag characters.
// #define MKFOURCC(a, b, c, d) ((a) | (b) << 8 | (c) << 16 | (uint32_t)(d) << 24)

	// VP8 related constants.
	const c_int VP8_SIGNATURE = 0x9d012a; // Signature in VP8 data.
	const c_int VP8_MAX_PARTITION0_SIZE = (1 << 19); // max size of mode partition
	const c_int VP8_MAX_PARTITION_SIZE  = (1 << 24); // max size for token partition
	const c_int VP8_FRAME_HEADER_SIZE = 10; // Size of the frame header within VP8 data.

	// VP8L related constants.
	const c_int VP8L_SIGNATURE_SIZE          = 1; // VP8L signature size.
	const c_int VP8L_MAGIC_BYTE              = 0x2f; // VP8L signature byte.
	const c_int VP8L_IMAGE_SIZE_BITS         = 14; // Number of bits used to store width and height.
	const c_int VP8L_VERSION_BITS            = 3; // 3 bits reserved for version.
	const c_int VP8L_VERSION                 = 0; // version 0
	const c_int VP8L_FRAME_HEADER_SIZE       = 5; // Size of the VP8L frame header.

	const c_int MAX_PALETTE_SIZE             = 256;
	const c_int MAX_CACHE_BITS               = 11;
	const c_int HUFFMAN_CODES_PER_META_CODE  = 5;
	const c_int ARGB_BLACK                   = (.)0xff000000;

	const c_int DEFAULT_CODE_LENGTH          = 8;
	const c_int MAX_ALLOWED_CODE_LENGTH      = 15;

	const c_int NUM_LITERAL_CODES            = 256;
	const c_int NUM_LENGTH_CODES             = 24;
	const c_int NUM_DISTANCE_CODES           = 40;
	const c_int CODE_LENGTH_CODES            = 19;

	const c_int MIN_HUFFMAN_BITS             = 2; // min number of Huffman bits
	const c_int NUM_HUFFMAN_BITS             = 3;

	// the maximum number of bits defining a transform is
	// MIN_TRANSFORM_BITS + (1 << NUM_TRANSFORM_BITS) - 1
	const c_int MIN_TRANSFORM_BITS           = 2;
	const c_int NUM_TRANSFORM_BITS           = 3;

	const c_int TRANSFORM_PRESENT            = 1; // The bit to be written when next data to be read is a transform.
	const c_int NUM_TRANSFORMS               = 4; // Maximum number of allowed transform in a bitstream.
	public enum VP8LImageTransformType
	{
		PREDICTOR_TRANSFORM      = 0,
		CROSS_COLOR_TRANSFORM    = 1,
		SUBTRACT_GREEN_TRANSFORM = 2,
		COLOR_INDEXING_TRANSFORM = 3
	};

	// Alpha related constants.
	const c_int ALPHA_HEADER_LEN            = 1;
	const c_int ALPHA_NO_COMPRESSION        = 0;
	const c_int ALPHA_LOSSLESS_COMPRESSION  = 1;
	const c_int ALPHA_PREPROCESSED_LEVELS   = 1;

	// Mux related constants.
	const c_int TAG_SIZE          = 4; // Size of a chunk tag (e.g. "VP8L").
	const c_int CHUNK_SIZE_BYTES  = 4; // Size needed to store chunk's size.
	const c_int CHUNK_HEADER_SIZE = 8; // Size of a chunk header.
	const c_int RIFF_HEADER_SIZE  = 12; // Size of the RIFF header ("RIFFnnnnWEBP").
	const c_int ANMF_CHUNK_SIZE   = 16; // Size of an ANMF chunk.
	const c_int ANIM_CHUNK_SIZE   = 6; // Size of an ANIM chunk.
	const c_int VP8X_CHUNK_SIZE   = 10; // Size of a VP8X chunk.

	const c_int MAX_CANVAS_SIZE     = (1 << 24); // 24-bit max for VP8X width/height.
	const c_ulonglong MAX_IMAGE_AREA      = (1 << 32); // 32-bit max for width x height.
	const c_int MAX_LOOP_COUNT      = (1 << 16); // maximum value for loop-count
	const c_int MAX_DURATION        = (1 << 24); // maximum duration
	const c_int MAX_POSITION_OFFSET = (1 << 24); // maximum frame x/y offset

	// Maximum chunk payload is such that adding the header and padding won't
	// overflow a uint32_t.
	const c_int MAX_CHUNK_PAYLOAD = ~0U - CHUNK_HEADER_SIZE - 1;
}