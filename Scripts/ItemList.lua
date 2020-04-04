PermanentItemList = 
{
  "afac",
  "spsh",
  "ajen",
  "bgst",
  "belv",
  "bspd",
  "cnob",
  "ratc",
  "rat6",
  "rat9",
  "clfm",
  "clsd",
  "crys",
  "dsum",
  "rst1",
  "gcel",
  "hval",
  "hcun",
  "rhth",
  "kpin",
  "lgdh",
  "rin1",
  "mcou",
  "odef",
  "penr",
  "pmna",
  "prvt",
  "rde2",
  "rde3",
  "rde4",
  "rlif",
  "ciri",
  "brac",
  "sbch",
  "rag1",
  "rwiz",
  "ssil",
  "stel",
  "evtl",
  "lhst",
  "war2",
}

ChargedItemList =
{
  "wild",
  "ankh",
  "fgsk",
  "fgdg",
  "whwd",
  "hlst",
  "shar",
  "infs",
  "mnst",
  "pdi2",
  "pdiv",
  "pghe",
  "pgma",
  "pnvu",
  "pomn",
  "pres",
  "fgrd",
  "rej3",
  "sand",
  "sres",
  "srrc",
  "sror",
  "wswd",
  "fgfh",
  "fgrg",
  "totw",
  "will",
  "wlsd",
  "woms",
  "wshs",
  "wcyc",
}

PowerUpItemList =
{
  "lmbr",
  "gfor",
  "gomn",
  "guvi",
  "gold",
  "manh",
  "rdis",
  "rhe3",
  "rma2",
  "rre2",
  "rhe2",
  "rhe1",
  "rre1",
  "rman",
  "rreb",
  "rres",
  "rsps",
  "rspd",
  "rspl",
  "rwat",
  "tdex",
  "rdx2",
  "texp",
  "tint",
  "tin2",
  "tpow",
  "tstr",
  "tst2",
}

ArtifactItemList =
{
  "ratf",
  "ckng",
  "desc",
  "modt",
  "ofro",
  "tkno",
}

PurchasableItemList = 
{
  "pclr",
  "hslv",
  "tsct",
  "plcl",
  "mcri",
  "moon",
  "phea",
  "pinv",
  "pnvl",
  "pman",
  "ritd",
  "rnec",
  "skul",
  "shea",
  "sman",
  "spro",
  "sreg",
  "shas",
  "stwp",
  "silk",
  "sneg",
  "ssan",
  "tcas",
  "tgrh",
  "tret",
  "vamp",
  "wneg",
  "wneu",
}

CampaignItemList =
{
  "kybl",
  "ches",
  "bzbe",
  "engs",
  "bzbf",
  "gmfr",
  "ledg",
  "kygh",
  "gopr",
  "azhr",
  "cnhn",
  "dkfw",
  "k3m3",
  "mgtk",
  "mort",
  "kymn",
  "k3m1",
  "jpnt",
  "k3m2",
  "phlt",
  "sclp",
  "sxpl",
  "sorf",
  "shwd",
  "skrt",
  "glsk",
  "kysn",
  "sehr",
  "thle",
  "dphe",
  "dthb",
  "ktrm",
  "vpur",
  "wtlg",
  "wolg",
}

MiscellaneousItemList =
{
  "amrc",
  "axas",
  "anfg",
  "pams",
  "arsc",
  "arsh",
  "asbl",
  "btst",
  "blba",
  "bfhr",
  "brag",
  "cosl",
  "rat3",
  "stpg",
  "crdt",
  "dtsb",
  "drph",
  "dust",
  "shen",
  "envl",
  "esaz",
  "frhg",
  "fgun",
  "fwss",
  "frgd",
  "gemt",
  "gvsm",
  "gobm",
  "tels",
  "rej4",
  "rej6",
  "grsl",
  "hbth",
  "sfog",
  "flag",
  "iwbr",
  "jdrn",
  "kgal",
  "klmm",
  "rej2",
  "rej5",
  "lnrn",
  "mlst",
  "mnsf",
  "rej1",
  "lure",
  "nspi",
  "nflg",
  "ocor",
  "ofr2",
  "ofir",
  "gldo",
  "oli2",
  "olig",
  "oslo",
  "oven",
  "oflg",
  "pgin",
  "pspd",
  "rde0",
  "rde1",
  "rnsp",
  "ram2",
  "ram4",
  "ram3",
  "ram1",
  "rugt",
  "rump",
  "horl",
  "schl",
  "ccmd",
  "rots",
  "scul",
  "srbd",
  "srtl",
  "sor1",
  "sora",
  "sor2",
  "sor3",
  "sor4",
  "sor5",
  "sor6",
  "sor7",
  "sor8",
  "sor9",
  "shcw",
  "shtm",
  "shhn",
  "shdt",
  "shrs",
  "sksh",
  "soul",
  "gsou",
  "sbok",
  "sprn",
  "spre",
  "stre",
  "stwa",
  "thdm",
  "tbak",
  "tbar",
  "tbsm",
  "tfar",
  "tlum",
  "tgxp",
  "tmsc",
  "tmmt",
  "uflg",
  "vddl",
  "ward",
}

AllItemList = {}


function ItemList_Init()
  -- Merge every table into one table:
  Utility.TableMerge(AllItemList, PermanentItemList)
  Utility.TableMerge(AllItemList, ChargedItemList)
  Utility.TableMerge(AllItemList, PowerUpItemList)
  Utility.TableMerge(AllItemList, ArtifactItemList)
  Utility.TableMerge(AllItemList, PurchasableItemList)
  Utility.TableMerge(AllItemList, CampaignItemList)
  Utility.TableMerge(AllItemList, MiscellaneousItemList)
end