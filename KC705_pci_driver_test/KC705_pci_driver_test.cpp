// KC705_pci_driver_test.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

#include <Windows.h>
#include <setupapi.h>
#include <initguid.h>


DEFINE_GUID(GUID_DEVINTERFACE_KC705pcidriver,
	0x0fe13054, 0xe5f5, 0x4d0f, 0x8f, 0x61, 0xe9, 0xcf, 0x88, 0xd6, 0x27, 0x74);
// {0fe13054-e5f5-4d0f-8f61-e9cf88d62774}


std::wstring GetInterfacePath(HDEVINFO DeviceInfoSet, PSP_DEVICE_INTERFACE_DATA pDeviceInterfaceData)
{
    DWORD requiredSize = 0;
    SetupDiGetDeviceInterfaceDetail(DeviceInfoSet, pDeviceInterfaceData, NULL, 0, &requiredSize, NULL);

    std::vector<char> buffer(requiredSize);
    PSP_DEVICE_INTERFACE_DETAIL_DATA_W pDeviceInterfaceDetailData = (PSP_DEVICE_INTERFACE_DETAIL_DATA_W)buffer.data();
    ZeroMemory(pDeviceInterfaceDetailData, buffer.size());
    pDeviceInterfaceDetailData->cbSize = sizeof(SP_DEVICE_INTERFACE_DETAIL_DATA_W);

    if (!SetupDiGetDeviceInterfaceDetailW(DeviceInfoSet, pDeviceInterfaceData, pDeviceInterfaceDetailData, buffer.size(), &requiredSize, NULL))
        return L"";

    return &pDeviceInterfaceDetailData->DevicePath[0];
}
BOOL FindBestInterface(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA pDeviceInfoData, PSP_DEVICE_INTERFACE_DATA pDeviceInterfaceData)
{
    ZeroMemory(pDeviceInterfaceData, sizeof(SP_DEVICE_INTERFACE_DATA));
    pDeviceInterfaceData->cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);
    ULONG InterfaceIndex = 0;

    if (!SetupDiEnumDeviceInterfaces(DeviceInfoSet, pDeviceInfoData, &GUID_DEVINTERFACE_KC705pcidriver, InterfaceIndex, pDeviceInterfaceData))
        return FALSE;

    return TRUE;
}
HANDLE CreateDevice()
{
	HDEVINFO DeviceInfoSet = SetupDiGetClassDevsW(&GUID_DEVINTERFACE_KC705pcidriver, NULL, NULL, DIGCF_DEVICEINTERFACE | DIGCF_PRESENT);

    SP_DEVINFO_DATA DeviceInfoData;
    ZeroMemory(&DeviceInfoData, sizeof(SP_DEVINFO_DATA));
    DeviceInfoData.cbSize = sizeof(SP_DEVINFO_DATA);
    ULONG DeviceIndex = 0;

    while (SetupDiEnumDeviceInfo(
        DeviceInfoSet,
        DeviceIndex,
        &DeviceInfoData))
    {
        DeviceIndex++;

        SP_DEVICE_INTERFACE_DATA DeviceInterfaceData;
        if (FindBestInterface(DeviceInfoSet, &DeviceInfoData, &DeviceInterfaceData))
        {
            std::wstring devicePath = GetInterfacePath(DeviceInfoSet, &DeviceInterfaceData);
            HANDLE hFile = CreateFileW(devicePath.c_str(), GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
            return hFile;
        }
    }

    if (DeviceInfoSet) {
        SetupDiDestroyDeviceInfoList(DeviceInfoSet);
    }
	return NULL;
}

int main()
{
	HANDLE h = CreateDevice();
    if (!h)
    {
        std::cout << "CreateDevice failed" << std::endl;
        return 1;
    }
    std::cout << "Created device successfully, handle: 0x" << std::hex << std::setfill('0') << h << std::endl;
    
    uint64_t size = 0x100;
    std::vector<BYTE> buffer(size);
    DWORD BytesRead = 0;

    BOOL b = ReadFile(h, buffer.data(), size, &BytesRead, NULL);
    std::cout << "ReadFile 0x" << size
        << " bytes, result: " << (bool)b << ", bytes read: 0x"
        << BytesRead << std::endl;

    for (uint64_t i = 0; i < size;)
    {
        uint64_t count = min(i + 16, size);
        for (; i < count; ++i)
        {
            std::cout << std::setw(2) << (int)buffer[i] << " ";
        }
        std::cout << std::endl;
    }

    CloseHandle(h);
    std::cout << "Done." << std::endl;
	return 0;
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
