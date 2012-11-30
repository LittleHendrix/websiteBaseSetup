echo "***** COMPILING CSS FOR PRODUCTION  *****"

echo "===== START ========================================";

@echo off 
set ruby_bin=C:\Ruby193\bin
set proj_path=%CD%\..
set temp_path=%proj_path%\compass\_tmp

if exist "%temp_path%" rd "%temp_path%" /Q /S
mkdir "%temp_path%"

cd "%proj_path%\compass"
call %ruby_bin%\compass.bat compile --time --force --sass-dir '%proj_path%\compass\sass' --css-dir '%temp_path%' --images-dir '%proj_path%\compass\stylesheets\images' -e production --output-style compressed --relative-assets --no-line-comments

cd "%temp_path%"
for %%f in (*.css) do (
	ren %%f %%~nf.min.css
)

cd "%proj_path%"
xcopy "%temp_path%\*.*" "%proj_path%\css" /S /R /Y
rd "%temp_path%" /Q /S
echo "===== END ==========================================";