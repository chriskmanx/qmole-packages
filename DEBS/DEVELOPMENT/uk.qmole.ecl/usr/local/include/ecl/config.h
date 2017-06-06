/* ecl/config.h.  Generated from configpre.h by configure.  */
/*
    config.h.in -- Template configuration file.
*/
/*
    Copyright (c) 1990, Giuseppe Attardi.
    Copyright (c) 2001, Juan Jose Garcia Ripoll.

    ECoLisp is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    See file '../Copyright' for full details.
*/

#if defined(_MSC_VER) || defined(__MINGW32__) || __WIN32__ || __WING64__
#define ECL_MS_WINDOWS_HOST
#endif

/*
 * If ECL_API has been predefined, that means we are building the core
 * library and, under windows, we must tell the compiler to export
 * extern functions from the shared library.
 * If ECL_API is not defined, we are simply building an application that
 * uses ECL and, under windows, we must tell the compiler that certain
 * will be imported from a DLL.
 */
#if defined(ECL_MS_WINDOWS_HOST) || defined(cygwin)
# define ECL_DLLEXPORT __declspec(dllexport)
# ifdef ECL_API
#  undef \
   ECL_API /* Avoid autoconf removing this */
#  define ECL_API __declspec(dllexport)
# else
#  define ECL_API __declspec(dllimport)
# endif
#else
# define ECL_DLLEXPORT
# ifdef ECL_API
#  undef \
   ECL_API /* Avoid autoconf removing this */
# endif
# define ECL_API
#endif

/* Decimal number made with the formula yymmvv */
#define ECL_VERSION_NUMBER 120201

/*
 * FEATURES LINKED IN
 */
/* Always use CLOS							*/
#define CLOS

/* Use GNU Multiple Precision library for bignums                       */
#ifndef DPP
#include "gmp.h"
#endif

/* Userland threads?							*/
/* #undef ECL_THREADS */
#ifdef ECL_THREADS
# if defined(ECL_MS_WINDOWS_HOST)
#  define ECL_WINDOWS_THREADS
# endif
/* # udef ECL_SEMAPHORES */
/* #undef ECL_RWLOCK */
#endif

/* __thread thread-local variables?                                     */
#ifndef openbsd
/* #undef WITH___THREAD */
#endif

/* Use Boehm's garbage collector					*/
#define GBC_BOEHM 1
#ifdef GBC_BOEHM
# ifdef ECL_THREADS
#   define GC_THREADS		/* For >= 7.2 */
# endif
# define ECL_DYNAMIC_VV
# include "gc.h"
/* GC >= 7.2 defines these macros to intercept thread functions, but
 * in doing so it breaks mingw. */
# if defined(ECL_MS_WINDOWS_HOST) && defined(_beginthreadex)
/* #  undef _beginthread */
/* #  undef _endthread */
/* #  undef _beginthreadex */
/* #  undef _endthreadex */
# endif
#endif

/* Network streams							*/
#define TCP 1
#if defined(TCP) && defined(ECL_MS_WINDOWS_HOST)
# define ECL_WSOCK
#endif

/* Foreign functions interface						*/
/* #undef ECL_FFI */

/* Support for Unicode strings */
#define ECL_UNICODE 21

/* Allow STREAM operations to work on arbitrary objects			*/
#define ECL_CLOS_STREAMS 1

/* Stack grows downwards						*/
#define ECL_DOWN_STACK 1

/* We have libffi and can use it                                        */
#define HAVE_LIBFFI 1

/* We have non-portable implementation of FFI calls			*/
/* Only used as a last resort, when libffi is missin                    */
#ifndef HAVE_LIBFFI
/* #undef ECL_DYNAMIC_FFI */
#endif

/* We use hierarchical package names, like in Allegro CL                */
#define ECL_RELATIVE_PACKAGE_NAMES 1

/* Use mprotect for fast interrupt dispatch				*/
#define ECL_USE_MPROTECT 1
#if defined(ECL_MS_WINDOWS_HOST)
# define ECL_USE_GUARD_PAGE
#endif

/* Integer types                        				*/
#include <stdint.h>
#define ecl_uint8_t uint8_t
#define ecl_int8_t int8_t
#define ecl_uint16_t uint16_t
#define ecl_int16_t int16_t
#define ecl_uint32_t uint32_t
#define ecl_int32_t int32_t
#define ecl_uint64_t uint64_t
#define ecl_int64_t int64_t
#define ecl_long_long_t long long
#define ecl_ulong_long_t unsigned long long

/*
 * C TYPES AND SYSTEM LIMITS
 */
/*
 * The integer type
 *
 * cl_fixnum must be an integer type, large enough to hold a pointer.
 * Ideally, according to the ISOC99 standard, we should use intptr_t,
 * but the required headers are not present in all systems. Hence we
 * use autoconf to guess the following values.
 */
#define ECL_INT_BITS		32
#define ECL_LONG_BITS		32
#define FIXNUM_BITS		32
#define MOST_POSITIVE_FIXNUM	((cl_fixnum)536870911)
#define MOST_NEGATIVE_FIXNUM	((cl_fixnum)-536870912)
#define MOST_POSITIVE_FIXNUM_VAL 536870911
#define MOST_NEGATIVE_FIXNUM_VAL -536870912

typedef int cl_fixnum;
typedef unsigned int cl_index;
typedef unsigned int cl_hashkey;

/*
 * The character type
 */
#define	CHAR_CODE_LIMIT	1114112 /* ASCII or unicode character code limit  */
typedef int32_t ecl_character;
typedef unsigned char ecl_base_char;

/*
 * Array limits
 */
#define	ARANKLIM	64		/*  array rank limit  		*/
#ifdef GBC_BOEHM
#define	ADIMLIM		536870911	/*  array dimension limit	*/
#define	ATOTLIM		536870911	/*  array total limit		*/
#else
#define	ADIMLIM		16*1024*1024	/*  array dimension limit	*/
#define	ATOTLIM		16*1024*1024	/*  array total limit		*/
#endif

/*
 * Function limits.
 *
 * In general, any of these limits must fit in a "signed int".
 */
/*	Maximum number of function arguments (arbitrary)		*/
#define CALL_ARGUMENTS_LIMIT 65536

/*	Maximum number of required arguments				*/
#define LAMBDA_PARAMETERS_LIMIT CALL_ARGUMENTS_LIMIT

/*	Numb. of args. which will be passed using the C stack		*/
/*	See cmplam.lsp if you change this value				*/
#define C_ARGUMENTS_LIMIT 64

/*	Maximum number of output arguments (>= C_ARGUMENTS_LIMIT)	*/
#define ECL_MULTIPLE_VALUES_LIMIT 64

/* A setjmp that does not save signals					*/
#define ecl_setjmp	_setjmp
#define ecl_longjmp	_longjmp

/*
 * Structure/Instance limits. The index to a slot must fit in the
 * "int" type. We also require ECL_SLOTS_LIMIT <= CALL_ARGUMENTS_LIMIT
 * because constructors typically require as many arguments as slots,
 * or more.
 */
#define ECL_SLOTS_LIMIT	32768

/* compiler understands long double                                     */
#define ECL_LONG_FLOAT 1
/* compiler understands complex                                         */
/* #undef HAVE_DOUBLE_COMPLEX */
/* #undef HAVE_FLOAT_COMPLEX */

/* We can use small, two-words conses, without type information		*/
#define ECL_SMALL_CONS 1

/*
 * C macros for inlining, denoting probable code paths and other stuff
 * that makes better code. Most of it is GCC specific.
 */
#if defined(__cplusplus) || (defined(__GNUC__) && !defined(__STRICT_ANSI__))
#define ECL_INLINE inline
#define ECL_CAN_INLINE 1
#else
#define ECL_INLINE
#define ECL_CAN_INLINE 0
#endif

#if !defined(__GNUC__)
# define ecl_likely(form) (form)
# define ecl_unlikely(form) (form)
# define ecl_attr_noreturn
#else
# if (__GNUC__ < 3)
#  define ecl_likely(form) (form)
#  define ecl_unlikely(form) (form)
# else
#  define ecl_likely(form) __builtin_expect(form,1)
#  define ecl_unlikely(form) __builtin_expect(form,0)
# endif
# if (__GNUC__ < 4)
#  define ecl_attr_noreturn
# else
#  define ecl_attr_noreturn __attribute__((noreturn))
# endif
#endif

#if defined(__SSE2__) || (defined(_M_IX86_FP) && _M_IX86_FP >= 2)
/* #undef ECL_SSE2 */
#endif

