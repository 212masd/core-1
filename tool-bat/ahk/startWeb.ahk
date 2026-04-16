#Requires AutoHotkey v2.0

#Requires AutoHotkey v2.0
#SingleInstance Force

; 按 F1 显示提示
F1:: {
    ToolTip "正在运行 AHK v2 脚本"
    SetTimer(ToolTip, -2000)
}

; 按 F2 打开控制台并输出文字
F2:: {
    DllCall("AllocConsole")
    con := FileOpen("CONOUT$", "w", "UTF-8")
    con.WriteLine("控制台已打开")
    con.WriteLine("这是最简单的脚本")
    con.WriteLine("按 F3 打开百度，F4 打开哔哩哔哩，F5 打开抖音，F6 打开斗宝网")
}
F10:: {
     DllCall("AllocConsole")
    con := FileOpen("CONOUT$", "w", "UTF-8")

    ; 一大段文本，直接一次性输出
    很多行文本 := "
(
F3::Run("https://www.baidu.com")

; F4 打开哔哩哔哩
F4::Run("https://www.bilibili.com")

; F5 打开抖音
F5::Run("https://www.douyin.com")

F6::Run("https://www.doubao.com/chat/")

)"

    con.Write(很多行文本)
}
#Requires AutoHotkey v2.0
#SingleInstance Force

; F3 打开百度
F3::Run("https://www.baidu.com")

; F4 打开哔哩哔哩
F4::Run("https://www.bilibili.com")

; F5 打开抖音
F5::Run("https://www.douyin.com")

F6::Run("https://www.doubao.com/chat/")

; ESC 退出脚本
ESC::ExitApp