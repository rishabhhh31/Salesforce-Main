import { LightningElement, wire } from 'lwc';
import getUserInfo from '@salesforce/apex/SpotifyHandler.getUserInfo';
import searchTrack from '@salesforce/apex/SpotifyHandler.searchTrack';
import getCurrentDeviceId from '@salesforce/apex/SpotifyHandler.getCurrentDeviceId';
export default class Spotify extends LightningElement {
    userInfo = {};
    isLoading = true;
    timeout = null;
    types = [];
    searchLoading = false;
    typeValue = 'track';
    searchResult = [];
    currentDeviceIds = [];
    connectedCallback(){
        let type = ["album", "artist", "playlist", "track", "show", "episode", "audiobook"];
        this.types = type.map(t=>{
            return {
                value: t,
                label: t
            }
        })
    }

    @wire(getUserInfo)
    spotifyUserInfo({ data, error }) {
        if (data) {
            console.log('data : ',data);
            this.userInfo = data;
            this.isLoading = false;
        } else if (error) {
            this.isLoading = false;
        }
    }

    @wire(getCurrentDeviceId)
    getCurrentDeviceId({ data, error }) {
        if (data) {
            console.log('currentDeviceIds',data);
            this.currentDeviceIds = data;
        } else if (error) {
            this.isLoading = false;
        }
    }

    get showUserInfo() {
        return Boolean(this.userInfo);
    }

    get getFullName(){
        return this.userInfo?.display_name + ' Spotify' ?? '' ;
    }

    openProfileOnWeb(){
        window.open(this.userInfo?.external_urls?.spotify, '_blank');
    }

    handleSearch(event){
        let searchKey = event.target.value;
        clearTimeout(this.timeout);
        this.searchLoading = true;
        this.timeout = setTimeout(async ()=>{
            if(searchKey?.length > 0){
                let response = await searchTrack({searchKey:searchKey, type:this.typeValue});
                if(response?.tracks?.items){
                    console.log(response.tracks.items);
                    this.searchResult = response.tracks.items;
                }else{
                    this.searchResult = [];
                }
            }
            this.searchLoading = false;
        }, 1000)
    }

    typeHandler(event){
        this.typeValue = event.detail.value
    }
}