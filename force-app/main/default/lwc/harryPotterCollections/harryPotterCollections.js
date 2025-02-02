import { LightningElement, wire } from 'lwc';
import getCharacters from '@salesforce/apex/HarryPotterAPIService.getCharacters';
import getCharacterById from '@salesforce/apex/HarryPotterAPIService.getCharacterById';
import UserLogo from "@salesforce/resourceUrl/UserLogo";
import { publish, MessageContext } from 'lightning/messageService';
import characterDetail from '@salesforce/messageChannel/characterDetails__c';

const COLUMNS = [
    {
        label: "Character",
        type: "customImage",
        typeAttributes: {
            imageUrl: { fieldName: "image" },
            altText: { fieldName: 'name' }
        },
        cellAttributes: { alignment: "center" },
    },
    { label: 'Name', fieldName: 'name' },
    { label: 'House', fieldName: 'house' },
    { label: 'Date of Birth', fieldName: 'formattedDateString', type: 'date' },
    { label: 'Ancestry', fieldName: 'ancestry' },
    { label: 'Actor Name', fieldName: 'actor' },
];

export default class HarryPotterCollections extends LightningElement {
    isLoading = false;
    columns = COLUMNS;
    allCharacterLabel = 'All Characters';
    hogwartsStudentsLabel = 'Hogwarts Students';
    hogwartsStaffLabel = 'Hogwarts Staff';
    allCharacters = [];
    hogwartsStudents = [];
    hogwartsStaff = [];
    hogwartsHouses = [];
    filteredCharacters = [];
    currentHouse = 'All';
    timeout;
    searchLoading = false;
    searchedCharacter = '';
    characterType = '';
    labels = [];

    connectedCallback() {
        this.labels = [this.allCharacterLabel, this.hogwartsStudentsLabel, this.hogwartsStaffLabel];
    }

    @wire(MessageContext)
    messageContext;

    async getCharacterData(fetchDataFunc) {
        try {
            this.isLoading = true;
            let houses = new Set();
            houses.add('All');

            let characterData = await fetchDataFunc({ characterType: this.characterType });
            const processedCharacters = characterData?.map(char => {
                let dob = char?.dateOfBirth;
                let formattedDateString = '';
                if (dob) {
                    let dateParts = dob.split('-');
                    formattedDateString = `${dateParts[2]}-${dateParts[1]}-${dateParts[0]}`;
                }
                if (char.house) {
                    houses.add(char.house);
                }
                if (char.image == "") {
                    char.image = UserLogo;
                }
                return { ...char, formattedDateString };
            });
            this.hogwartsHouses = [];
            this.hogwartsHouses = [...houses].map(house => ({ label: house, value: house }));
            return processedCharacters;
        } catch (error) {
            console.error(error);
        } finally {
            this.isLoading = false;
        }
    }

    async getAllHarryPotterCharacters() {
        this.allCharacters = await this.getCharacterData(getCharacters);
        this.filteredCharacters = [...this.allCharacters];
    }

    async getAllHarryPotterStaffCharacters() {
        this.hogwartsStaff = await this.getCharacterData(getCharacters);
        this.filteredCharacters = [...this.hogwartsStaff];
    }

    async getAllHogwartsStudentsCharacters() {
        this.hogwartsStudents = await this.getCharacterData(getCharacters);
        this.filteredCharacters = [...this.hogwartsStudents];
    }

    handleActive(event) {
        this.searchedCharacter = '';
        let currentTab = event.target.value;
        if (currentTab === this.allCharacterLabel) {
            this.characterType = '';
            this.getAllHarryPotterCharacters();
        } else if (currentTab === this.hogwartsStudentsLabel) {
            this.characterType = 'students';
            this.getAllHogwartsStudentsCharacters();
        } else if (currentTab === this.hogwartsStaffLabel) {
            this.characterType = 'staff';
            this.getAllHarryPotterStaffCharacters();
        }
    }

    handleHouseChange(event) {
        this.currentHouse = event.detail.value;
        let currentTab = event.target.dataset.tabName;
        if (currentTab === this.allCharacterLabel) {
            this.filterByHouseAndName(this.allCharacters);
        } else if (currentTab === this.hogwartsStudentsLabel) {
            this.filterByHouseAndName(this.hogwartsStudents);
        } else if (currentTab === this.hogwartsStaffLabel) {
            this.filterByHouseAndName(this.hogwartsStaff);
        }
    }

    filterByHouseAndName(characters) {
        let filtered = characters;

        if (this.currentHouse !== 'All') {
            filtered = filtered.filter(char => char.house === this.currentHouse);
        }
        if (this.searchedCharacter) {
            filtered = filtered.filter(char => char.name.includes(this.searchedCharacter));
        }

        this.filteredCharacters = filtered;
    }

    searchByCharacterName(event) {
        clearTimeout(this.timeout);
        let currentTab = event.target.dataset.tabName;
        this.searchLoading = true;
        this.searchedCharacter = event.target.value;
        this.timeout = setTimeout(() => {
            if (currentTab === this.allCharacterLabel) {
                this.filterByHouseAndName(this.allCharacters);
            } else if (currentTab === this.hogwartsStudentsLabel) {
                this.filterByHouseAndName(this.hogwartsStudents);
            } else if (currentTab === this.hogwartsStaffLabel) {
                this.filterByHouseAndName(this.hogwartsStaff);
            }
            this.searchLoading = false;
        }, 1000);
    }

    async characterSelection(event) {
        let characterId = event.detail.config.value;
        const payload = { characterId: characterId };
        publish(this.messageContext, characterDetail, payload);
    }
}