using System;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Interop;
using System.Text;

using static libwebp.libwebp;

namespace example;

static class Program
{
	static int Main(params String[] args)
	{
		Debug.WriteLine($"{WebPGetDecoderVersion()}");
		return 0;
	}
}