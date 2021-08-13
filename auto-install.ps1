$PACKAGE_NAME = "<STEP>"
$PACKAGE = $PACKAGE_NAME, ".ssimpkg" -join ""
$STEP = Join-Path "<WORKING FOLDER>" -ChildPath "helloworldEnhanced" | Join-Path -ChildPath "<STEP>"
$EXE = "C:\Program Files\SyncroSim\SyncroSim.PackageManager.exe"

& $EXE --uninstall=$PACKAGE_NAME
& $EXE --create=$STEP --file=$PACKAGE --force 
& $EXE --finstall=$PACKAGE