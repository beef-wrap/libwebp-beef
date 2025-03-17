// Copyright 2010 Google Inc. All Rights Reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the COPYING file in the root of the source
// tree. An additional intellectual property rights grant can be found
// in the file PATENTS. All contributing project authors may
// be found in the AUTHORS file in the root of the source tree.
// -----------------------------------------------------------------------------
//
//  Common types + memory wrappers
//
// Author: Skal (pascal.massimino@gmail.com)

using System;
using System.Interop;

namespace libwebp;

extension libwebp
{
	typealias char = c_char;
	typealias int8_t = c_char;
	typealias uint8_t = c_uchar;
	typealias int16_t = c_short;
	typealias uint16_t = c_ushort;
	typealias int32_t = c_int;
	typealias uint32_t = c_uint;
	typealias uint64_t = c_ulonglong;
	typealias int64_t = c_longlong;
	typealias size_t = uint;

	// Allocates 'size' bytes of memory. Returns NULL upon error. Memory
	// must be deallocated by calling WebPFree(). This function is made available
	// by the core 'libwebp' library.
	[CLink] public static extern void* WebPMalloc(size_t size);

	// Releases memory returned by the WebPDecode*() functions (from decode.h).
	[CLink] public static extern void WebPFree(void* ptr);
}