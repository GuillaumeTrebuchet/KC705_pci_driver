/*++

Module Name:

    device.h

Abstract:

    This file contains the device definitions.

Environment:

    Kernel-mode Driver Framework

--*/

#include "public.h"

EXTERN_C_START

typedef struct
{
    ULONG Leds;
    LARGE_INTEGER DmaSrcAddress;
    LARGE_INTEGER DmaDstAddress;
    ULONG DmaLength;
    ULONG DmaStatus;
} KC705_REGISTERS, * PKC705_REGISTERS;

//
// The device context performs the same job as
// a WDM device extension in the driver frameworks
//
typedef struct _DEVICE_CONTEXT
{
    ULONG PrivateDeviceData;  // just a placeholder
    BUS_INTERFACE_STANDARD BusInterface;
    PHYSICAL_ADDRESS MemPhysAddress;
    ULONG MemSize;
    PVOID MemMappedAddress;
    WDFDMAENABLER DmaEnabler;
    WDFDMATRANSACTION DmaTransaction;
    WDFINTERRUPT Interrupt;
    PKC705_REGISTERS Registers;
} DEVICE_CONTEXT, *PDEVICE_CONTEXT;

//
// This macro will generate an inline function called DeviceGetContext
// which will be used to get a pointer to the device context memory
// in a type safe manner.
//
WDF_DECLARE_CONTEXT_TYPE_WITH_NAME(DEVICE_CONTEXT, DeviceGetContext)

//
// Function to initialize the device and its callbacks
//
NTSTATUS
KC705pcidriverCreateDevice(
    _Inout_ PWDFDEVICE_INIT DeviceInit
    );

EXTERN_C_END
