echo off
setlocal enabledelayedexpansion
set list =["readme.md","urls.txt","links.txt","config.ini","油猴脚本.js","其他相关文件.txt"]

:: 定义文件夹列表
set "folders=项目文档,资源文件,代码文件,配置文件,脚本文件,其他文件"




set projectName=MyProject
mkdir %projectName%
cd %projectName%
:: 遍历列表创建文件夹
for %%i in (%folders%) do (
    echo 创建文件夹: %%i
    mkdir "%%i" 2>nul
)


echo .>readme.md
echo "这是一个项目文件夹。" > readme.md
echo "请在此处添加项目相关的文件和资料。" >> readme.md
echo .>urls.txt
echo .>links.txt
echo .>config.ini
echo .>油猴脚本.js
echo .>其他相关文件.txt
dir /b>project_files.txt
dir /b
pause
cd  ..



          
@REM # initproject.bat 脚本分析

@REM ## 脚本概览

@REM **initproject.bat** 是一个用于初始化项目的批处理脚本，位于 `d:\b战\BBDown_1.6.3_1080p\core\tool-bat\init` 目录下。

@REM ## 脚本内容

@REM ```batch
@REM echo off
@REM setlocal enabledelayedexpansion


@REM set projectName=MyProject
@REM mkdir %projectName%
@REM cd %projectName%
@REM echo .>readme.md
@REM echo "这是一个项目文件夹。" > readme.md
@REM echo "请在此处添加项目相关的文件和资料。" >> readme.md
@REM echo .>urls.txt
@REM echo .>links.txt
@REM echo .>config.ini
@REM echo .>油猴脚本.js
@REM echo .>其他相关文件.txt
@REM dir /b>project_files.txt
@REM dir /b
@REM pause
@REM cd  ..
@REM ```

@REM ## 功能分析

@REM ### 核心功能

@REM 1. **创建项目文件夹**：创建一个名为 `MyProject` 的文件夹
@REM 2. **生成项目文件**：在项目文件夹中创建以下文件：
@REM    - `readme.md`：项目说明文件，包含基本的项目信息
@REM    - `urls.txt`：用于存储 URL 链接的文本文件
@REM    - `links.txt`：用于存储链接的文本文件
@REM    - `config.ini`：配置文件
@REM    - `油猴脚本.js`：用户脚本文件
@REM    - `其他相关文件.txt`：其他相关文件
@REM 3. **生成文件列表**：创建 `project_files.txt` 文件，记录项目文件夹中的所有文件
@REM 4. **显示文件列表**：在命令行中显示项目文件夹中的所有文件
@REM 5. **暂停执行**：等待用户按任意键继续
@REM 6. **返回上级目录**：执行完毕后返回上级目录

@REM ### 工作原理

@REM 1. **关闭命令回显**：`echo off` 命令关闭命令行中的命令回显，使输出更加整洁
@REM 2. **启用延迟变量扩展**：`setlocal enabledelayedexpansion` 命令启用延迟变量扩展，允许在循环和条件语句中使用变量
@REM 3. **创建文件夹**：`mkdir %projectName%` 命令创建项目文件夹
@REM 4. **进入文件夹**：`cd %projectName%` 命令进入项目文件夹
@REM 5. **创建文件**：使用 `echo .>文件名` 命令创建空文件，使用 `echo 内容 > 文件名` 命令创建包含内容的文件
@REM 6. **列出文件**：`dir /b` 命令以简洁模式列出文件夹中的所有文件
@REM 7. **暂停执行**：`pause` 命令暂停脚本执行，等待用户按任意键
@REM 8. **返回上级目录**：`cd ..` 命令返回上级目录

@REM ## 使用方法

@REM 1. **运行脚本**：双击 `initproject.bat` 文件或在命令行中执行该脚本
@REM 2. **查看结果**：脚本执行完成后，会在当前目录下创建一个 `MyProject` 文件夹
@REM 3. **检查文件**：打开 `MyProject` 文件夹，查看生成的文件
@REM 4. **自定义项目**：根据需要修改 `projectName` 变量，创建不同名称的项目文件夹

@REM ## 配置与扩展

@REM ### 自定义项目名称

@REM 要创建不同名称的项目文件夹，只需修改脚本中的 `projectName` 变量：

@REM ```batch
@REM set projectName=YourProjectName
@REM ```

@REM ### 添加更多文件

@REM 要在项目中添加更多文件，只需在脚本中添加相应的 `echo .>文件名` 或 `echo 内容 > 文件名` 命令：

@REM ```batch
@REM echo .>additional_file.txt
@REM echo "这是一个额外的文件。" > additional_file.txt
@REM ```

@REM ### 修改 readme.md 内容

@REM 要修改 `readme.md` 文件的内容，只需修改脚本中的相应命令：

@REM ```batch
@REM echo "# 项目名称" > readme.md
@REM echo "项目描述" >> readme.md
@REM echo "- 功能 1" >> readme.md
@REM echo "- 功能 2" >> readme.md
@REM ```

@REM ## 技术特点

@REM 1. **简单易用**：脚本结构简单，易于理解和修改
@REM 2. **自动化**：自动创建项目文件夹和基本文件，减少手动操作
@REM 3. **可扩展性**：可以根据需要修改项目名称和添加更多文件
@REM 4. **清晰明了**：脚本执行过程中会显示创建的文件列表，便于查看结果
@REM 5. **跨平台**：批处理脚本适用于 Windows 系统

@REM ## 注意事项

@REM 1. **路径问题**：脚本会在当前目录下创建项目文件夹，确保在正确的目录中执行脚本
@REM 2. **权限问题**：确保有足够的权限在当前目录中创建文件夹和文件
@REM 3. **文件覆盖**：如果已存在同名的项目文件夹，脚本会尝试在其中创建文件，可能会覆盖现有文件
@REM 4. **编码问题**：脚本中的中文内容可能会在某些命令行环境中显示为乱码，建议使用 UTF-8 编码执行脚本

@REM ## 输入输出示例

@REM #### 输入输出示例

@REM **输入**：
@REM 1. 双击运行 `initproject.bat`

@REM **输出**：
@REM 1. 命令行窗口显示：
@REM    ```
@REM    readme.md
@REM    urls.txt
@REM    links.txt
@REM    config.ini
@REM    油猴脚本.js
@REM    其他相关文件.txt
@REM    project_files.txt
@REM    请按任意键继续. . .
@REM    ```

@REM 2. 当前目录下创建了 `MyProject` 文件夹，包含以下文件：
@REM    - `readme.md`：包含 "这是一个项目文件夹。" 和 "请在此处添加项目相关的文件和资料。"
@REM    - `urls.txt`：空文件
@REM    - `links.txt`：空文件
@REM    - `config.ini`：空文件
@REM    - `油猴脚本.js`：空文件
@REM    - `其他相关文件.txt`：空文件
@REM    - `project_files.txt`：包含项目文件夹中的所有文件列表

@REM ## 总结

@REM **initproject.bat** 是一个简单实用的项目初始化脚本，它可以：

@REM 1. 快速创建一个新的项目文件夹
@REM 2. 生成项目所需的基本文件
@REM 3. 记录项目文件列表
@REM 4. 提供清晰的执行反馈

@REM 通过修改脚本中的项目名称和文件内容，可以根据不同的项目需求进行定制。这个脚本特别适合快速搭建新项目的基本结构，减少手动创建文件的工作量。

@REM 该脚本的设计思路简洁明了，代码结构清晰，是学习批处理脚本编写的好例子。
        