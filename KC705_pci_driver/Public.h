/*++

Module Name:

    public.h

Abstract:

    This module contains the common declarations shared by driver
    and user applications.

Environment:

    user and kernel

--*/

//
// Define an Interface Guid so that apps can find the device and talk to it.
//

DEFINE_GUID (GUID_DEVINTERFACE_KC705pcidriver,
    0x0fe13054,0xe5f5,0x4d0f,0x8f,0x61,0xe9,0xcf,0x88,0xd6,0x27,0x74);
// {0fe13054-e5f5-4d0f-8f61-e9cf88d62774}
