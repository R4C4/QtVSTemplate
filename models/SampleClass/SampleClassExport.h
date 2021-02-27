
#ifndef SampleClass_DLL_H
#define SampleClass_DLL_H

#ifdef SHARED_EXPORTS_BUILT_AS_STATIC
#  define SampleClass_DLL
#  define SAMPLECLASS_NO_EXPORT
#else
#  ifndef SampleClass_DLL
#    ifdef SampleClass_EXPORTS
        /* We are building this library */
#      define SampleClass_DLL __declspec(dllexport)
#    else
        /* We are using this library */
#      define SampleClass_DLL __declspec(dllimport)
#    endif
#  endif

#  ifndef SAMPLECLASS_NO_EXPORT
#    define SAMPLECLASS_NO_EXPORT 
#  endif
#endif

#ifndef SAMPLECLASS_DEPRECATED
#  define SAMPLECLASS_DEPRECATED __declspec(deprecated)
#endif

#ifndef SAMPLECLASS_DEPRECATED_EXPORT
#  define SAMPLECLASS_DEPRECATED_EXPORT SampleClass_DLL SAMPLECLASS_DEPRECATED
#endif

#ifndef SAMPLECLASS_DEPRECATED_NO_EXPORT
#  define SAMPLECLASS_DEPRECATED_NO_EXPORT SAMPLECLASS_NO_EXPORT SAMPLECLASS_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef SAMPLECLASS_NO_DEPRECATED
#    define SAMPLECLASS_NO_DEPRECATED
#  endif
#endif

#endif /* SampleClass_DLL_H */
