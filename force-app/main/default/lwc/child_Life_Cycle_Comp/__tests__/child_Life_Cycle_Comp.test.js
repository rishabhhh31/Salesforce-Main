import { createElement } from 'lwc';
import Child_Life_Cycle_Comp from 'c/child_Life_Cycle_Comp';

describe('c-child-life-cycle-comp', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('TODO: test case generated by CLI command, please fill in test logic', () => {
        // Arrange
        const element = createElement('c-child-life-cycle-comp', {
            is: Child_Life_Cycle_Comp
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // const div = element.shadowRoot.querySelector('div');
        expect(1).toBe(1);
    });
});