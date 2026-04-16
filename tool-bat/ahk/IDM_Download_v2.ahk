; IDM 自动下载脚本 (AHK v2)
; 快捷键说明
; F1 - 记录视频中心坐标
; F2 - 记录IDM下载按钮坐标
; F3 - 单次自动下载
; F4 - 显示坐标信息
; F5 - 重置坐标
; F6 - 批量下载多标签页
; F7 - 设置批量数量
; F8 - 设置切换延迟
; Esc - 退出

#SingleInstance Force
CoordMode "Mouse", "Screen"

; 全局坐标
global VideoX := 551
global VideoY := 387
global IdmX := 983
global IdmY := 158

; 批量设置
global BatchCount := 5
global BatchDelay := 3000


; ==============================
; F1 记录视频坐标
; ==============================
F1:: {
    global VideoX, VideoY
    MouseGetPos &x, &y
    VideoX := x
    VideoY := y
    ToolTip "视频坐标已记录：(" x "," y ")"
    SetTimer RemoveToolTip, -2000
}

; ==============================
; F2 记录IDM按钮坐标
; ==============================
F2:: {
    global IdmX, IdmY
    MouseGetPos &x, &y
    IdmX := x
    IdmY := y
    ToolTip "IDM坐标已记录：(" x "," y ")"
    SetTimer RemoveToolTip, -2000
}

; ==============================
; F3 单次下载
; ==============================
F3:: {
    global VideoX, VideoY, IdmX, IdmY
    if (VideoX = 0 || VideoY = 0) {
        ToolTip "请先按 F1 记录视频坐标！"
        SetTimer RemoveToolTip, -2000
        return
    }
    if (IdmX = 0 || IdmY = 0) {
        ToolTip "请先按 F2 记录IDM坐标！"
        SetTimer RemoveToolTip, -2000
        return
    }

    ToolTip "开始执行下载..."
    MouseMove VideoX, VideoY
    Click
   
    Sleep 800
    MouseMove IdmX, IdmY
    Sleep 300
    Click
    Sleep 500
    ToolTip "已点击IDM下载按钮"
    SetTimer RemoveToolTip, -2000
}

; ==============================
; F4 显示坐标
; ==============================
F4:: {
    global VideoX, VideoY, IdmX, IdmY
    MouseGetPos &mx, &my
    str := "鼠标：(" mx "," my ")`n视频：(" VideoX "," VideoY ")`nIDM：(" IdmX "," IdmY ")"
    ToolTip str
    SetTimer RemoveToolTip, -3000
}

; ==============================
; F5 重置坐标
; ==============================
F5:: {
    global VideoX, VideoY, IdmX, IdmY
    VideoX := 0
    VideoY := 0
    IdmX := 0
    IdmY := 0
    ToolTip "坐标已重置"
    SetTimer RemoveToolTip, -2000
}

; ==============================
; F6 批量下载
; ==============================
F6:: {
    global VideoX, VideoY, IdmX, IdmY, BatchCount, BatchDelay
    if (VideoX = 0 || VideoY = 0 || IdmX = 0 || IdmY = 0) {
        ToolTip "请先记录坐标！"
        SetTimer RemoveToolTip, -2000
        return
    }

    ToolTip "开始批量下载：" BatchCount " 个"
    Sleep 500

    Loop BatchCount {
        i := A_Index
        ToolTip "正在处理第 " i "/" BatchCount " 个"
        sleep 500
        MouseMove VideoX, VideoY
        sleep 800
        send "{F3}"   
        Sleep BatchDelay
        Send "{Ctrl down}{Tab}"
        Sleep 150  ; 延长延时，确保标签切换完成
        Send "{Ctrl up}"
        Sleep 500 ; 等待标签页切换完成
        
    }

    ToolTip "批量下载完成！"
    SetTimer RemoveToolTip, -3000
}

; ==============================
; F7 设置批量数量
; ==============================


; ==============================
; F8 设置延迟
; ==============================
F8:: {
    hotkeyHelp := "IDM 自动下载脚本快捷键说明：`n`n"
    hotkeyHelp .= "F1 - 记录视频中心坐标`n"
    hotkeyHelp .= "F2 - 记录IDM下载按钮坐标`n"
    hotkeyHelp .= "F3 - 单次自动下载`n"
    hotkeyHelp .= "F4 - 显示坐标信息`n"
    hotkeyHelp .= "F5 - 重置坐标`n"
    hotkeyHelp .= "F6 - 批量下载多标签页`n"
    hotkeyHelp .= "F7 - 设置批量数量`n"
    hotkeyHelp .= "F8 - 显示快捷键说明`n"
    hotkeyHelp .= "Esc - 退出`n`n"
    hotkeyHelp .= "当前设置：`n"
    hotkeyHelp .= "批量数量：" . BatchCount . "`n"
    
    
    MsgBox %hotkeyHelp%
}

; ==============================
; 清理提示
; ==============================
RemoveToolTip() {
    ToolTip
}

; ==============================
; Esc 退出
; ==============================
Esc::ExitApp