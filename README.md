# GLWA Mobile Data Collection App

<img src="https://glwa.wpenginepowered.com/wp-content/uploads/2018/06/logo-glwa.svg" height=120> <img src="https://github.com/mblabwsu/glwa/assets/56197948/23c91bcf-a5b9-4df1-9209-9f595a8cbe62" height=120>


The Great Lakes Water Authority (GLWA) will use this app to collect watershed contamination data from testing sites throughout the southeast Michigan region. 

**Principal Investigators**
- Professor Jeff Ram -<br />
Wayne State University Medical School,<br />
Department of Physiology
- Professor Amar Basu -<br />
Wayne State University,<br />
Department of Electrical and Computer Engineering

**App Developers**
* Grey Slatina -<br />
Wayne State University,<br />
Department of Computer Science
* Manpreet Singh -<br />
Wayne State University,<br />
Department of Computer Science
* Maaz Shaikh -<br />
Wayne State Universit,<br />
Department of Computer Science
* Nick Zuke -<br />
Wayne State University,<br />
Department of Computer Science

#### Notes From The Developers
<details>
<summary>File Structure</summary>
    
    In our codebase we opted for a specific file structure
    to help with a request for scalability. You'll notice
    a 'feature first' methodology. Meaning we broke the
    features into seperate folders. Therefore the is some
    explaining need for the following folders.

<details>
<summary>Widgets</summary>

    Here is where we stored all built widgets that live
    within a feature. These could be auto generated tile
    cards, app bars, and controllers.


</details>

<details>
<summary>Assets</summary>

    Here we have stored all assests used in the project,
    this is different from the screenshots folder. This
    contains logos and icons used.


</details>

<details>
<summary>Services</summary>

    Since this application connects to an external IoT
    device we needed a place to store this code. Here
    will contain all the Python scripts and servers for
    the IoT device.

</details>

</details>


## Device Compatibility
<details>
<summary>Versions</summary>

- IOS: v11.0
- Android: v8.0 api 26

</details>

## Technology Needed

<details>
<summary>Technology Stack</summary>
<b>Important:</b>

    The application runs with a Flutter framework using
    primarily Dart for its main programming language. When
    installing Flutter, Dart will be installed as well.

- [Flutter](https://docs.flutter.dev/get-started/install)
- [Python](https://www.datacamp.com/blog/how-to-install-python)
- [FirebaseCLI](https://firebase.google.com/docs/cli#install-cli-windows)
- [FirebaseSKD](https://firebase.google.com/docs/flutter/setup?platform=ios)

</details>

<details>
<summary>IDEs</summary>
<b>Important:</b>

    The development team primarily used VScode for everything
    related to this application. Any IDE that supports Flutter,
    Dart, and the required emulators should suffice. But our
    set up instructions will be for VScode.

- [VScode](https://code.visualstudio.com/download)

</details>

<details>
    <summary>Emulators / Devices</summary>
    <br>

    1. Apple Device [Developer Mode]

    2. Android Device [Developer Mode]

    3. IOS Emulator

    4. Android Emulator

</details>

## Installation
<details>
<summary>Step 1</summary>
<b>Important</b>:

    Make sure you have installed all required technologies
    before beginning this step!

<b>Clone the Repository</b> <br />
&ensp;Run this command in your terminal:

    git clone https://github.com/Greysushii/microbial_source_tracking.git

<b>Repository Help</b> <br />
&ensp; - [GitHub](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

</details>

<details>
<summary>Step 2</summary>
<b>Being on the correct branch</b><br />
&ensp;Run this commands in your terminal:

    git checkout 'name of branch being targeted'

&ensp;For the most recent version of the application checkout the main branch &ensp;in the repository.

&ensp;The Development branch holds the most recent commits.


</details>

<details>
<summary>Step 3</summary>
<b>Resolving Dependencies</b><br />
&ensp;Run these commands in order to resolve any dependencies issues:

    flutter clean
    flutter pub get     
      
</details>

<details>
<summary>Step 4</summary>
<b>Change Emulators:</b><br />
&ensp;While in VScode:

    1. Windows [control+shift+p]
    2. MacOS   [command+shift+p]

&ensp;This will bring up the search function in VScode<br />
&ensp;Enter the following command:

    flutter: select device
   
&ensp;This will bring up your select device menu.<br />
&ensp;Select from the listed devices.<br />
&ensp;Once a target device is selected, run the application with F5.
    
</details>

## Screenshots

<details>
<summary>Login / Registration</summary>

<img src="Screenshots/Login Page(APP).png" alt="Login" width="180"/>
<img src="Screenshots/Registration Page(APP).png" alt="Register" width="180"/>

</details>

<details>
<summary>Home Page / Explanation Tiles</summary>

<img src="Screenshots/Home Page(APP).png" alt="Home" width="180"/>
<img src="Screenshots/Home Page Tile(APP).png" alt="Tiles" width="180"/>

</details>

<details>
<summary>Configuration / Bluetooth Connection / Wi-Fi Connection </summary>

<img src="Screenshots/Config Page(APP).png" alt="Config" width="180"/>
<img src="Screenshots/Bluetooth Page(APP).png" alt="BLE" width="180"/>
<img src="Screenshots/Wifi Page(APP).png" alt="Wifi" width="180"/>

</details>

<details>
<summary>Start Test / IoT RestAPI </summary>

<img src="Screenshots/Start Test(APP).png" alt="Start" width="180"/>
<img src="Screenshots/Pi DataPipe(APP).png" alt="Pi" width="720" height="400"/>

</details>

<details>
<summary>History / Upload / Retreival Page</summary>

<img src="Screenshots/History Page(APP).png" alt="History" width="180"/>
<img src="Screenshots/Upload Popup(APP).png" alt="Upload" width="180"/>
<img src="Screenshots/Results Page(APP).png" alt="Results" width="180"/>

</details>

<details>
<summary>Settings / Account Data</summary>

<img src="Screenshots/Settings Page(APP).png" alt="Settings" width="180"/>
<img src="Screenshots/Account Settings(APP).png" alt="Account" width="180"/>


</details>

