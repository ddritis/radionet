
```bash
# .rsc script with fixed date
/export file=([/system/identity/get name] . "_setup_20260507")

# backup file fixed date
/system/backup/save name=([/system/identity/get name] . "_full_20260507")

/export file=([/system/identity/get name] )

/system/backup/save name=([/system/identity/get name] )

# .rsc with passwords
/export file=([/system/identity/get name] . "_FULL_SENSITIVE") show-sensitive

### .rsc with dynamic date
:local ds [/system clock get date]; \
:local y ([:pick $ds 7 11]); \
:local m ([:pick $ds 0 3]); \
:local d ([:pick $ds 4 6]); \
/export file=([/system/identity/get name] . "_" . $y . "-" . $m . "-" . $d . ".rsc")

### backup with dynamic date
:local ds [/system clock get date]; \
:local y ([:pick $ds 7 11]); \
:local m ([:pick $ds 0 3]); \
:local d ([:pick $ds 4 6]); \
/system backup save name=([/system/identity/get name] . "_" . $y . "-" . $m . "-" . $d . ".backup")

### .rsc + backup with dynamic date
{
:local name [/system identity get name];
:local date [/system clock get date];
:local y ([:pick $date 7 11]);
:local m ([:pick $date 0 3]);
:local d ([:pick $date 4 6]);
:if ([:pick $d 0 1] = " ") do={ :set d ("0" . [:pick $d 1 2]) };
:local filename ($name . "_" . $y . "-" . $m . "-" . $d);
/export file=$filename;
/system backup save name=$filename;
}
```