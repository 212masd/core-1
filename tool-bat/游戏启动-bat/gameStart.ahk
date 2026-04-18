AutoHotkey v2 游戏启动器
; ==============================================
; 按 F2 显示游戏菜单 + 控制台输出 + 数字启动
; ==============================================

#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; 启用控制台
DllCall("AllocConsole")

; 控制台输出函数
ConsolePrint(text) {
    FileAppend(text . "`n", "*"
}

; 控制台清空函数
ConsoleClear() {
    DllCall("system", "Str", "cls")
}

; 读取控制台输入
ConsoleReadLine() {
    return FileReadLine("*", 0)
}

; F2 热键
F2:: {
    ConsoleClear()
    ConsolePrint("==================================================")
    ConsolePrint("             游戏路径与启动命令大全")
    ConsolePrint("==================================================")
    ConsolePrint("")
    ConsolePrint("──────────────────────────────────────────")
    ConsolePrint("【1】背包战争")
    ConsolePrint("【2】罪恶帝国")
    ConsolePrint("【3】为了国王2")
    ConsolePrint("【4】勇气与荣耀1949")
    ConsolePrint("【5】IDUN")
    ConsolePrint("【6】陷阵之志")
    ConsolePrint("【7】铁血联盟3")
    ConsolePrint("【8】方境战记")
    ConsolePrint("【9】Menace")
    ConsolePrint("【10】海妖沉默")
    ConsolePrint("【11】寂静之歌")
    ConsolePrint("【12】擦拭者")
    ConsolePrint("【13】100%鲜橙汁")
    ConsolePrint("【14】跨越深渊")
    ConsolePrint("【15】动物井")
    ConsolePrint("【16】小丑牌")
    ConsolePrint("【17】卡牌生存：奇幻森林")
    ConsolePrint("【18】卡牌生存：热带岛屿")
    ConsolePrint("【19】天空之卡")
    ConsolePrint("【20】密教模拟器")
    ConsolePrint("【21】Decktamer")
    ConsolePrint("【22】骰子法师")
    ConsolePrint("【23】Hustle Battle Card Gamers")
    ConsolePrint("【24】邪恶冥刻")
    ConsolePrint("【25】小小地牢故事")
    ConsolePrint("【26】LONESTAR")
    ConsolePrint("【27】深海威胁")
    ConsolePrint("【28】霓虹白客")
    ConsolePrint("【29】网络爬行")
    ConsolePrint("【30】伊甸之路")
    ConsolePrint("【31】怀旧像素")
    ConsolePrint("【32】Shambles")
    ConsolePrint("【33】幕府对决")
    ConsolePrint("【34】杀戮尖塔2")
    ConsolePrint("【35】毁灭之岛")
    ConsolePrint("【36】巫师之昆特牌：王权陨落")
    ConsolePrint("【37】展翅翱翔")
    ConsolePrint("【38】黑色巫术")
    ConsolePrint("【39】神之亵渎")
    ConsolePrint("【40】核子反应堆")
    ConsolePrint("【41】死亡细胞")
    ConsolePrint("【42】银河护卫兵")
    ConsolePrint("【43】尘埃异变")
    ConsolePrint("【44】祝你好死")
    ConsolePrint("【45】空洞骑士：丝之歌")
    ConsolePrint("【46】莱卡：鲜血铸就")
    ConsolePrint("【47】MIO")
    ConsolePrint("【48】月痕")
    ConsolePrint("【49】九日")
    ConsolePrint("【50】奥日与黑暗森林")
    ConsolePrint("【51】盗贼遗产2")
    ConsolePrint("【52】盐与避难所")
    ConsolePrint("【53】SELINI")
    ConsolePrint("【54】铁尾传奇")
    ConsolePrint("【55】莫比乌斯机器")
    ConsolePrint("【56】武士之灵")
    ConsolePrint("【57】信使")
    ConsolePrint("【58】东方月神夜")
    ConsolePrint("──────────────────────────────────────────")
    ConsolePrint("")
    ConsolePrint("==================================================")
    ConsolePrint("             所有游戏信息输出完毕")
    ConsolePrint("==================================================")
    ConsolePrint("")
    ConsolePrint("请输入数字（1-58）按回车启动，输入 0 退出：")

    ; 读取输入
    input := ConsoleReadLine()

    ; ==============================================
    ; 数字 1~58 对应启动游戏
    ; ==============================================
    if (input = "1") {
        Run("G:\game\新建文件夹\game For.The.King.II\BackpackBattleChess\BackpackBattleChess\BackpackBattleChess.exe")
    } else if (input = "2") {
        Run("G:\game\新建文件夹\game For.The.King.II\Empire.of.Sin.Premium.Edition\Empire.of.Sin.Premium.Edition\EmpireOfSin.exe")
    } else if (input = "3") {
        Run("G:\game\新建文件夹\game For.The.King.II\For.The.King.II\For.The.King.II\For The King II.exe")
    } else if (input = "4") {
        Run("G:\game\新建文件夹\game For.The.King.II\Grit.and.Valor.1949.v1.4.0\Grit.and.Valor.1949.v1.4.0\Grit and Valor.exe")
    } else if (input = "5") {
        Run("G:\game\新建文件夹\game For.The.King.II\IDUN\IDUN\IDUN.exe")
    } else if (input = "6") {
        Run("G:\game\新建文件夹\game For.The.King.II\Into the Breach\Breach.exe")
    } else if (input = "7") {
        Run("G:\game\新建文件夹\game For.The.King.II\JA3\B393\JA3.exe")
    } else if (input = "8") {
        Run("G:\game\新建文件夹\game For.The.King.II\Lost In Fantaland\Lost In Fantaland\Lost In Fantaland.exe")
    } else if (input = "9") {
        Run("G:\game\新建文件夹\game For.The.King.II\Menace\Menace\Menace.exe")
    } else if (input = "10") {
        Run("G:\game\新建文件夹\game For.The.King.II\Silence.of.the.Siren.Build.18222862\Silence.of.the.Siren.Build.18222862\Silence of the Siren.exe")
    } else if (input = "11") {
        Run("G:\game\新建文件夹\game For.The.King.II\Songs.Of.Silence\Songs.Of.Silence\SongsOfSilence.exe")
    } else if (input = "12") {
        Run("G:\game\新建文件夹\game For.The.King.II\The.Scouring\The.Scouring\TheScouring.exe")
    } else if (input = "13") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\100.Percent.Orange.Juice.Build.21354600\100.Percent.Orange.Juice.Build.21354600\100% Orange Juice.exe")
    } else if (input = "14") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Across the Obelisk\AcrossTheObelisk.exe")
    } else if (input = "15") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Animal.Well.Build.16245418\Animal Well.exe")
    } else if (input = "16") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Balatro.v1.0.1m\Balatro.v1.0.1m\Balatro.exe")
    } else if (input = "17") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Card Survival Fantasy Forest\Card Survival - Fantasy Forest.exe")
    } else if (input = "18") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Card Survival Tropical Island\Card Survival - Tropical Island.exe")
    } else if (input = "19") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Card.en.Ciel.Build.21763757\Card-en-Ciel.exe")
    } else if (input = "20") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Cultist Simulator\cultistsimulator.exe")
    } else if (input = "21") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Decktamer\Decktamer.exe")
    } else if (input = "22") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\DICEOMANCER v1.1.18\DICEOMANCER\Diceomancer.exe")
    } else if (input = "23") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Hustle Battle Card Gamers\Game.exe")
    } else if (input = "24") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Inscryption.v8988081\Inscryption.exe")
    } else if (input = "25") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Little Dungeon Stories\Little Dungeon Stories.exe")
    } else if (input = "26") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\LONESTAR.Early.Access\LONESTAR.Early.Access\LONESTAR.exe")
    } else if (input = "27") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Menace.from.the.Deep.v1.16-P2P\Menace.from.the.Deep.v1.16-P2P\Menace from the Deep.exe")
    } else if (input = "28") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Neon.White.Build.20230503\Neon White.exe")
    } else if (input = "29") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\NET.CRAWL\NetCrawl.exe")
    } else if (input = "30") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\One Step From Eden\OSFE.exe")
    } else if (input = "31") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Perfect.Hand.of.Nostalpix.Build.20930422\nostalpix.exe")
    } else if (input = "32") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Shambles\Shambles\Shambles.exe")
    } else if (input = "33") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Shogun.Showdown.Build.20620547\Shogun.Showdown.Build.20620547\ShogunShowdown.exe")
    } else if (input = "34") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Slay the Spire 2\SlayTheSpire2.exe")
    } else if (input = "35") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\These.Doomed.Isles.Build.15079280\TheseDoomedIsles.exe")
    } else if (input = "36") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Thronebreaker The Witcher Tales\Thronebreaker The Witcher Tales\Thronebreaker.exe")
    } else if (input = "37") {
        Run("G:\game\新建文件夹\game Slay the Spire 2\Wingspan\Wingspan\Wingspan.exe")
    } else if (input = "38") {
        Run("G:\game\新建文件夹\game Tails of Iron\Black.Witchcraft.Build.10763057\BlackWitchcraft.exe")
    } else if (input = "39") {
        Run("G:\game\新建文件夹\game Tails of Iron\Blasphemous.Build.20206233\Blasphemous.exe")
    } else if (input = "40") {
        Run("G:\game\新建文件夹\game Tails of Iron\Code.Reactors.Build.20019983\CodeReactors.exe")
    } else if (input = "41") {
        Run("G:\game\新建文件夹\game Tails of Iron\Dead.Cells.v35.7\Game\deadcells.exe")
    } else if (input = "42") {
        Run("G:\game\新建文件夹\game Tails of Iron\Gal.Guardians.Servants.of.the.Dark.v1.6.1\game.exe")
    } else if (input = "43") {
        Run("G:\game\新建文件夹\game Tails of Iron\GRIME.Build.13454705\GRIME.exe")
    } else if (input = "44") {
        Run("G:\game\新建文件夹\game Tails of Iron\Have.a.Nice.Death.v1.0.4.55150-P2P\HaveaNiceDeath.exe")
    } else if (input = "45") {
        Run("G:\game\新建文件夹\game Tails of Iron\Hollow Knight Silksong\Hollow Knight Silksong.exe")
    } else if (input = "46") {
        Run("G:\game\新建文件夹\game Tails of Iron\Laika.Aged.Through.Blood.v1.0.14-P2P\Laika Aged through Blood.exe")
    } else if (input = "47") {
        Run("G:\game\新建文件夹\game Tails of Iron\MIO Memories in Orbit\mio.exe")
    } else if (input = "48") {
        Run("G:\game\新建文件夹\game Tails of Iron\Moonscars.v1.6.009\Moonscars.exe")
    } else if (input = "49") {
        Run("G:\game\新建文件夹\game Tails of Iron\Nine Sols\NineSols.exe")
    } else if (input = "50") {
        Run("G:\game\新建文件夹\game Tails of Iron\Ori and the Blind Forest\oriDE.exe")
    } else if (input = "51") {
        Run("G:\game\新建文件夹\game Tails of Iron\Rogue.Legacy.2.Build.11192820\Rogue Legacy 2.exe")
    } else if (input = "52") {
        Run("G:\game\新建文件夹\game Tails of Iron\Salt and Sanctuary\salt.exe")
    } else if (input = "53") {
        Run("G:\game\新建文件夹\game Tails of Iron\SELINI\SELINI.exe")
    } else if (input = "54") {
        Run("G:\game\新建文件夹\game Tails of Iron\Tails of Iron\TOI.exe")
    } else if (input = "55") {
        Run("G:\game\新建文件夹\game Tails of Iron\The Mobius Machine\TheMobiusMachine.exe")
    } else if (input = "56") {
        Run("G:\game\新建文件夹\game Tails of Iron\The Spirit of the Samurai\samurai.exe")
    } else if (input = "57") {
        Run("G:\game\新建文件夹\game Tails of Iron\The.Messenger.Build.20243257\TheMessenger.exe")
    } else if (input = "58") {
        Run("G:\game\新建文件夹\game Tails of Iron\Touhou Luna Nights\touhou_luna_nights.exe")
    } else if (input = "0") {
        ConsolePrint("`n已退出菜单。")
        return
    }

    ConsolePrint("`n启动完成！按 F2 再次打开菜单。")
}