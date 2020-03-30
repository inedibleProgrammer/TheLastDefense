HumanUpgradeList =
{
  "Rhan",
  "Rhpm",
  "Rhrt",
  "Rhra",
  "Rhcd",
  "Rhss",
  "Rhde",
  "Rhfc",
  "Rhfl",
  "Rhgb",
  "Rhfs",
  "Rhlh",
  "Rhac",
  "Rhme",
  "Rhar",
  "Rhri",
  "Rhse",
  "Rhpt",
  "Rhst",
  "Rhhb",
  "Rhla",
  "Rhsb",
}

OrcUpgradeList = 
{
  "Ropm",
  "Robk",
  "Robs",
  "Robf",
  "Roen",
  "Rovs",
  "Rolf",
  "Ropg",
  "Rows",
  "Rorb",
  "Rost",
  "Rost",
  "Rosp",
  "Rowt",
  "Roar",
  "Rome",
  "Rora",
  "Rotr",
  "Rwdm",
  "Rowd",
}

UndeadUpgradeList = 
{
  "Rupm",
  "Ruba",
  "Rubu",
  "Ruac",
  "Rura",
  "Rucr",
  "Rusp",
  "Rupc",
  "Ruex",
  "Rufb",
  "Rugf",
  "Rune",
  "Rusl",
  "Rusm",
  "Rusf",
  "Ruar",
  "Rume",
  "Ruwb",
}

NightElfUpgradeList =
{
  "Resi",
  "Repm",
  "Recb",
  "Redc",
  "Redt",
  "Rehs",
  "Reht",
  "Reib",
  "Reeb",
  "Reec",
  "Remk",
  "Rema",
  "Renb",
  "Rerh",
  "Rers",
  "Resc",
  "Resm",
  "Resw",
  "Reuv",
  "Remg",
  "Repb",
  "Rews",
}

AllRacesUpgradeList = {}

function UpgradeList_Init()
   -- Merge the four races into one table:
   Utility.TableMerge(AllRacesUpgradeList, HumanUpgradeList)
   Utility.TableMerge(AllRacesUpgradeList, OrcUpgradeList)
   Utility.TableMerge(AllRacesUpgradeList, UndeadUpgradeList)
   Utility.TableMerge(AllRacesUpgradeList, NightElfUpgradeList)
end