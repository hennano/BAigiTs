@rem BAigiTs.bat v1.0
@rem created by ScTi
@rem arguments %1:execute label name
@echo off
setlocal enabledelayedexpansion
pushd %~dp0
call :init %*
call :%EXELABEL% %*
popd
endlocal
pause
exit /b

@rem argument %1:execute label name
:init
  @call setLF.bat
  rem set LF=^



  @rem ���s���郉�x���̎w��
  if "%1"=="log" (
    set EXELABEL=log
  ) else if "%1"=="state" (
    set EXELABEL=state
  ) else if "%1"=="export" (
    set EXELABEL=export
  ) else if "%1"=="action" (
    set EXELABEL=action
  ) else (
    set EXELABEL=main
    @rem �t�@�C���̏�����
    @rem �e��T�u�E�C���h�E�̋N��
    @rem �������I������
  )
exit /b

@rem ���[�e�B���e�B--------------------------------------

@rem �L�[���͎�t
@rem arguments %1:keyMode %2:manualInputkey
:keyInput
  setlocal
  if %1==1 (
    @rem set keyinput=wasdefq
    set keyinput=wasde
  ) else if %1==2 (
    set keyinput=wasd
  ) else if %1==3 (
    set keyinput=1234567890
  ) else if %1==4 (
    set keyinput=yn
  ) else if %1==manual (
    set keyinput=%2
  ) else if %1==menu (
    set keyinput=ad%2
  )
  choice /c:%keyinput% /n /m ">"
  set /a input=%errorlevel%-1
  set ret=!keyinput:~%input%,1!
  endlocal&set ret=%ret%
exit /b

@rem ���ꕶ���ϊ�
@rem argument %1:convertString
:toSpcialCharacter
  setlocal 
  set str=%1
  set str=%str:[sp]= %
  set str=%str:[pst]=^%^%^%^%%
  endlocal&set str=%str%
exit /b

@rem csv�̑S���C���|�[�g
@rem arguments %1:filePath %2:valiableAssigned
:importCSVAll
  set i=-1
  for /F "skip=1 delims=" %%A in (%1) do (
    set n=-1
    set /a i=i+1
    for %%a in (%%A) do (
      set /a n=n+1
      call set %2[%%i%%.%%n%%]=%%a
    )
  )
exit /b

@rem csv�̃C���|�[�g
@rem arguments %1:filePath %2:xstart %3:xend %4:ystart %5:yend %6:valiableAssigned %7:isrelative %8:xinstart %9:yinstart
:importCSV
  setlocal
  @rem �萔�錾
  set SKIP_LOWS=1
  set ESCAPE_CHARACTER=$
  @rem �������
  set xweight=0
  set yweight=0
  if %2 lss 0 ( set xmin=0) else ( set xmin=%2)
  if %4 lss 0 ( set ymin=0) else ( set ymin=%4)
  if "%7"=="true" (
    if not "%8"=="" ( set xweight=+%8-%2) else (set /a xweight=-%2)
    if not "%9"=="" ( set yweight=+%9-%4) else (set /a yweight=-%4)
  )
  set filename=%1
  if %filename:~-4%==.csv set filename=%filename:~0,-4%
  if not %SKIP_LOWS%==0 set skiprows=skip^=%SKIP_LOWS%
  @rem csv�t�@�C���ǂݍ���(y����)
  set i=-1
  for /F "%skiprows% delims=" %%A in (%filename%.csv) do (
    set j=-1
    set /a i+=1
    @rem echo %%A
    set tmp=%%A
    if !i! geq %ymin% call :importCSVSub1 "!tmp:,=%ESCAPE_CHARACTER%,!" %xmin% %3 %ymin% %5 %6 %7 %8 %9
  )&if !i! geq %5 goto importCSVTh1
  :importCSVTh1
  @rem ���[�h�����ϐ���setlocal�O�Ɏ����o��
  set tmpdata=%tmpdata:;=!LF!%
  for /f "tokens=1,2 delims=," %%i in ("!tmpdata!") do endlocal&set %6[%%i]=%%j
exit /b

  @rem csv�t�@�C���ǂݍ���(x����)
  :importCSVSub1
    for %%a in (%~1) do (
    set /a j+=1
    @rem �͈͓����f
    if !j! geq %2 ( if !j! leq %3 (
      set tmpc=%%a
      set /a x=!j!+%xweight%
      set /a y=!i!+%yweight%
      set tmpdata=!tmpdata!!x!.!y!,!tmpc:%ESCAPE_CHARACTER%=!;
    ))
  )&if !j! gtr %3 goto importCSVTh2
  :importCSVTh2
exit /b

@rem �F�t���o��
@rem arguments %1:echoStrings %2:color
:cecho
  setlocal
  set color=%2
  if not defined color set color=00
  cd ./data/tmp
  if not exist %1 <nul > "%1" cmd /k prompt $h
  findstr /a:%color% "." "%1" nul
  cd %~dp0
  endlocal
exit /b

@rem kv�t�@�C���C���|�[�g
@rem argument %1:filepath
:importKV
  for /F %%A in (%1.kv) do set %%A
exit /b

@rem kv�t�@�C���G�N�X�|�[�g
@rem arguments %1:filepath %2-:keys
:exportKV
  for %%A in (%*) do (
    if not %%A==%1 (
      echo %%A=!%%A!>>%1
    )
  )
exit /b
