// KC705_pci_driver_test.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <sstream>

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

void readmem(HANDLE h, int size)
{
    std::vector<BYTE> buffer(size);
    DWORD BytesRead = 0;

    BOOL b = ReadFile(h, buffer.data(), size, &BytesRead, NULL);
    std::cout << "ReadFile 0x" << size
        << " bytes, result: " << (bool)b << ", bytes read: 0x"
        << BytesRead << std::endl;

    for (int i = 0; i < BytesRead;)
    {
        int count = min(i + 16, BytesRead);
        for (; i < count; ++i)
        {
            std::cout << std::setw(2) << (int)buffer[i] << " ";
        }
        std::cout << std::endl;
    }
}
void writemem(HANDLE h, const std::vector<uint8_t>& buffer)
{
    DWORD BytesWritten = 0;

    BOOL b = WriteFile(h, (LPVOID)buffer.data(), buffer.size(), &BytesWritten, NULL);
    std::cout << "WriteFile 0x" << buffer.size()
        << " bytes, result: " << (bool)b << ", bytes written: 0x"
        << BytesWritten << std::endl;
}
#define KC705_IOCTRL_WRITE_REG 0x1
#define KC705_IOCTRL_READ_REG 0x2

struct KC705_WRITE_REG_DATA
{
    uint64_t address;
    uint32_t value;
};
void writereg(HANDLE h, uint64_t address, uint32_t value)
{
    KC705_WRITE_REG_DATA data = { 0 };
    data.address = address;
    data.value = value;
    DWORD BytesReturned = 0;
    BOOL b = DeviceIoControl(h, KC705_IOCTRL_WRITE_REG, &data, sizeof(data), NULL, 0, &BytesReturned, NULL);
    std::cout << "return value: " << (bool)b << std::endl;
}

std::vector<std::string> GetCommandParams()
{
    std::vector<std::string> cmd;
    std::string s;
    std::getline(std::cin, s);
    std::stringstream ss(s);
    while (!ss.eof())
    {
        std::string s;
        ss >> s;
        if (s.size()) // if input is "   " s is empty
            cmd.push_back(s);
    }
    return cmd;
}

bool ToUInt64(const std::string& s, uint64_t* p)
{
    uint64_t u = 0;
    size_t idx = 0;
    if (s.size() > 2 && s.substr(0, 2) == "0x")
    {
        u = std::stoull(s.substr(2), &idx, 16);
        idx += 2;
    }
    else
        u = std::stoull(s, &idx, 10);

    *p = u;
    return idx == s.size();
}
bool ToUInt8Hex(const std::string& s, uint8_t* p)
{
    if (s.size() != 2)
        return false;

    size_t idx = 0;
    unsigned long i = std::stoul(s, &idx, 16);
    *p = (uint8_t)i;
    return idx == s.size() && s.size() == 2 && i >= 0 && i <= 0xFF;
}
bool ReadDataLine(std::vector<uint8_t>& buffer, int ofs)
{
    std::string parts[16];
    for (int i = 0; i < 16; ++i)
        std::cin >> parts[i];

    for (auto s : parts)
    {
        if (!ToUInt8Hex(s, &buffer[ofs++]))
        {
            std::cout << "Invalid syntax" << std::endl;
            return false;
        }
    }
    return true;
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
    
    while (true)
    {
        std::cout << "enter command (h for help):" << std::endl;
        auto params = GetCommandParams();
        if (params.size() == 0)
            continue;

        std::string cmd = params[0];
        if (cmd == "h")
        {
            std::cout << "setoffset <offset> (set <offset> as current offset in the device's memory)" << std::endl;
            std::cout << "readmem <size> (read <size> bytes from the device's memory)" << std::endl;
            std::cout << "writemem <size> (write <size> bytes to the device's memory, bytes must be input after. 16 bytes per line, 2 hex per byte)" << std::endl;
            std::cout << "writereg <address> <value> (write the given value to the register at address)" << std::endl;
            std::cout << "exit (close the application)" << std::endl;
        }
        else if (cmd == "exit")
        {
            break;
        }
        else if (cmd == "setoffset")
        {
            if (params.size() != 2)
            {
                std::cout << "wrong args" << std::endl;
                continue;
            }

            uint64_t ofs = 0;
            if (!ToUInt64(params[1], &ofs))
            {
                std::cout << "unable to read offset" << std::endl;
                continue;
            }

            SetFilePointer(h, ofs, NULL, FILE_BEGIN);
        }
        else if(cmd == "readmem")
        {
            if (params.size() != 2)
            {
                std::cout << "wrong args" << std::endl;
                continue;
            }

            uint64_t size = 0;
            if (!ToUInt64(params[1], &size))
            {
                std::cout << "unable to read size" << std::endl;
                continue;
            }
            if (size <= 0 || size >= 0x10000)
            {
                std::cout << "size must be between 0 and 0x10000" << std::endl;
                continue;
            }

            readmem(h, size);
        }
        else if (cmd == "writemem")
        {
            if (params.size() != 2)
            {
                std::cout << "wrong args" << std::endl;
                continue;
            }

            uint64_t size = 0;
            if (!ToUInt64(params[1], &size))
            {
                std::cout << "unable to read size" << std::endl;
                continue;
            }
            if (size <= 0 || size >= 0x10000 || (size & 0xF))
            {
                std::cout << "size must be between 0 and 0x10000 and a multiple of 16" << std::endl;
                continue;
            }

            std::vector<uint8_t> buffer(size);
            for (int i = 0; i < size / 16; ++i)
            {
                if (!ReadDataLine(buffer, i * 16))
                    continue;
            }
            writemem(h, buffer);
        }
        else if (cmd == "writereg")
        {
            if (params.size() != 3)
            {
                std::cout << "wrong args" << std::endl;
                continue;
            }

            uint64_t address = 0;
            if (!ToUInt64(params[1], &address) || address >= 0x100)
            {
                std::cout << "wrong address" << std::endl;
                continue;
            }
            uint64_t value = 0;
            if (!ToUInt64(params[2], &value) || value > 0xFFFFFFFF)
            {
                std::cout << "wrong value" << std::endl;
                continue;
            }
            writereg(h, address, value);
        }
        else
        {
            std::cout << "unknown command" << std::endl;
        }
    }

    CloseHandle(h);
    std::cout << "Done." << std::endl;
	return 0;
}