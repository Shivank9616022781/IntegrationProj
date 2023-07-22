import { LightningElement } from 'lwc';
import cqSynceMethod from '@salesforce/apex/CQConfigurationController.syncPartData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CqSyncRecord extends LightningElement {

    handleSync = () => {
        cqSynceMethod()
            .then(result => {
                console.log(result);
                console.log(result['ERROR']);

                if(result['NOERROR'] != null && result['NOERROR'] != undefined){
                    this.showSuccessMessage(result['NOERROR']);
                }else{
                    this.showErrorMessage(result['ERROR']);
                }
            })
            .catch(error => {
                this.showErrorMessage(error);
            });
    }

    showErrorMessage(errorMessage) {
        const evt = new ShowToastEvent({
            title: 'Error in Sync',
            message: errorMessage,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showSuccessMessage(succesMessage) {
        const evt = new ShowToastEvent({
            title: 'Sync Completed',
            message: succesMessage,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}