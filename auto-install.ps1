$PACKAGE_NAME = "helloworldEnhanced"
$PACKAGE = $PACKAGE_NAME, ".ssimpkg" -join ""
$STEP = Join-Path "<WORKING FOLDER>" -ChildPath $PACKAGE_NAME | Join-Path -ChildPath "<STEP>"
$EXE = "C:\Program Files\SyncroSim\SyncroSim.PackageManager.exe"

& $EXE --uninstall=$PACKAGE_NAME
& $EXE --create=$STEP --file=$PACKAGE --force 
& $EXE --finstall=$PACKAGE