sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"anubhav/ui/managepo/test/integration/pages/purchaseOrderSetList",
	"anubhav/ui/managepo/test/integration/pages/purchaseOrderSetObjectPage",
	"anubhav/ui/managepo/test/integration/pages/purchaseItemsSetObjectPage"
], function (JourneyRunner, purchaseOrderSetList, purchaseOrderSetObjectPage, purchaseItemsSetObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('anubhav/ui/managepo') + '/test/flp.html#app-preview',
        pages: {
			onThepurchaseOrderSetList: purchaseOrderSetList,
			onThepurchaseOrderSetObjectPage: purchaseOrderSetObjectPage,
			onThepurchaseItemsSetObjectPage: purchaseItemsSetObjectPage
        },
        async: true
    });

    return runner;
});

