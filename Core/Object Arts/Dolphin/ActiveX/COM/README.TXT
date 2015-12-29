Dolphin OLE/COM Support
-----------------------

The Dolphin base system includes a package which provide basic OLE/COM support (but not OLE compound documents, OLE Automation, or ActiveX support yet). In addition to this, there are a number of sample packages to help you familiarize yoursef with the way COM works in Dolphin Smalltalk. These can be installed into your image with the package browser and are described below.

--------
1) Packages\OLE\OLE COM.pac

This package is, by default, installed in your Dolphin image and implements the basic COM functionality. This includes: call-out and implementation of COM interfaces, Dolphin as an out-of-process server, class factories, automatic reference counting, IUnknown implementation, aggregation. The package implements IUnknown, IMalloc, IEnumXXXX, and IClassFactory.

2) Packages\OLE\OLE Structured Storage.pac

Interface classes for using OLE compound files. Includes IEnumSTATSTG, ILockBytes, ISequentialStream, IStorage, and IStream. Provides an implementation of ILockBytes (OLELockBytes) for storing OLE compound files into ByteArrays.

3) Samples\OLE\RandomStream Sample.pac

The RandomStream Sample demonstrates Dolphin's basic COM facilities. This sample implements the same interface as the Random Number Generator sample in ObjectShare's Visual Smalltalk 3.1 (tm), and includes a marshalling DLL so that Dolphin can act as a server for Visual Smalltalk. The package comment includes further instructions.

4) Samples\EnumRECT Sample.pac

This is an implementation of the EnumRECT Sample COM interface described in Kraig Brockschmidt's book, Inside OLE 2. It demonstrates the simplicity of implementing and using OLE interfaces in Dolphin, and if you have a copy of the book you should be able to see how easy it is to map from C++ classes.

