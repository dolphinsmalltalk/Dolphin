#pragma once

HRESULT LoadImage(IDolphinStart* piDolphin, HMODULE hModule, LPCWSTR fileName, LPVOID& imageData, size_t& imageSize);
