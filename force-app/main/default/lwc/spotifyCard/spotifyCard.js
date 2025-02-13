import { LightningElement, api } from 'lwc';
import playPreviousSong from '@salesforce/apex/SpotifyHandler.playPreviousSong';
import playNextSong from '@salesforce/apex/SpotifyHandler.playNextSong';
import playSongById from '@salesforce/apex/SpotifyHandler.playSongById';

export default class SpotifyCard extends LightningElement {
    @api trackItem;
    @api deviceIds;
    connectedCallback(){
        console.log('trackItem=>',this.trackItem);
        console.log('deviceIds=>',this.deviceIds);
    }

    async playerHandler(event){
        let value = event.target.value;
        if(value == 'play'){
            let response = await playSongById({deviceIds:this.deviceIds, uri:this.trackItem.uri});
            console.log('play',response);
        }
        if(value == 'pause'){}
        if(value == 'next'){
            let response = await playNextSong({deviceIds:this.deviceIds});
            console.log('next',response);
        }
        if(value == 'back'){
            let response = await playPreviousSong({deviceIds:this.deviceIds});
            console.log('back',response);   
        }
        console.log('playerHandler');
    }

    openSpotify(event){
        let externalUrl = event.target.dataset.externalUrl;
        window.open(externalUrl, '_blank');
    }

    get imageUrl(){
        return this.trackItem?.album?.images[0]?.url;
    }
}