class Connection{

  static String ip = "http://103.236.154.131:70/api/Navkar/";
  // static String ipNew = "http://122.200.22.58:76/api/Navkar/";
  static String ipNew = "http://103.236.154.131:97/api/Navkar/";
  static String ipc = "http://122.200.19.33:65/api/Navkar/";
  // static String ipcNew = "http://trackermobileapi.gadlogistics.in/api/GAD/";
  // static String ipNew = "http://trackermobileapi.gadlogistics.in/api/GAD/";


  static String dashboard = ip+"api/Navkar/GetMenuDetails?UserID=";

  //ips for ICD
  static String login = ipNew+"ValidateLogin";
  static String detailIcd = ipNew+"GetDashboardICD";
  static String dmr = ipNew+"GetDMR";
  // static String dmrNew = ipNew+"GetDMRYardIII";
  static String ifcOut = ipNew+"GetCustomerWiseOutStandingAgingICD";
  static String ifcBill = ipNew+"GetBillingDMRICD";
  static String ifcOverall = ipNew+"GetOverallOutstandingICD";
  static String ifcCustAeging = ipNew+"GetOutstandingCustWiseAgingICD";
  static String totalOutIcd = ipNew+"GetTotalOutStandingAgingICD";
  static String kdmIcd = ipNew+"GetKDMWiseReportForICD";
  static String collectionIcd = ipNew+"GetBillingCollectionICD";
  static String performnaceIcd = ipNew+"GetSalesPersonMonthlyReportICD";

  static String getLocation = ipNew+"GetYardLocation";
  static String saveLocation = ipNew+"InsertYardData";
  static String getSearchContainer = ipNew+"GetSearchContainerNoYard";
  static String getYardDataSummary = ipNew+"GetYardDataSummary";

  //ips for CFS
  static String detailCfs = ipc+"GetDashboardCFS";
  static String dmrCfs = ipc+"GetDMRCFS";
  static String dmrYard1 = ipc+"GetDMRYArdI";
  static String dmrYard2 = ipc+"GetDMRYArdII";
  static String dmrYard3 = ipc+"GetDMRYArdIII";
  static String cfsOut = ipc+"GetCustomerWiseOutStandingAgingCFS";
  // static String cfsBill = ipcNew+"GetBillingDMRCFS";
  static String cfsBill = ipc+"GetBillingDMRCFS";
  static String cfsOverall = ipc+"GetOverallOutstandingCFS";
  static String cfsCustAeging = ipc+"GetOutstandingCustWiseAgingCFS";
  static String totalOutCfs = ipc+"GetTotalOutStandingAgingCFS";
  static String kdmCfs = ipc+"GetKDMWiseReportForCFS";
  // static String collectionCfs = ipcNew+"GetBillingCollectionCFS";
  static String collectionCfs = ipc+"GetBillingCollectionCFS";
  static String performanceCfs = ipc+"GetSalesPersonMonthlyReportCFS";

}