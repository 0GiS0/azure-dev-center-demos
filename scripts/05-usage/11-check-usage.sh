az devcenter admin usage list -l $LOCATION \
--query "[].{name:name.value, currentValue:currentValue}" \
-o table