import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["files"]
  
  addFile(event) {
    const originalInput = event.target
    const originalParent = originalInput.parentNode

    const selectedFile = document.createElement("div")
    selectedFile.className = "selected-file"
    selectedFile.append(originalInput)

    var labelNode = document.createElement("label");
    var textElement = document.createTextNode(originalInput.files[0].name);
    labelNode.appendChild(textElement);
    selectedFile.appendChild(labelNode);

    // Move the input element that we've added files to, to the list of
    // selected elements
    this.filesTarget.append(selectedFile)

    // Create a new blank, input field to use going forward
    const newInput = originalInput.cloneNode()

    // Clear the filelist - some browsers maintain the filelist when cloning,
    // others don't
    newInput.value = ""

    // Add it to the DOM where the original input was
    originalParent.append(newInput)
  }
}
