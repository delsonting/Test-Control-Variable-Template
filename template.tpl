___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Test or Control Group",
  "description": "Variables that determine Test or Control based on a random number generator that runs every time variable is used.  Returns true if test, false if control.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "testFreq",
    "displayName": "Percentage of \"Test\" (true) Results",
    "simpleValueType": true,
    "defaultValue": 50,
    "valueValidators": [
      {
        "type": "PERCENTAGE"
      }
    ],
    "help": "Frequency of \"Test\" outcomes as an integer percentage (0-100)"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

//Runs everytime variable is used, if needed to associate with session consider storing the result somewhere (eg cookie)

const log = require('logToConsole');
const generateRandom = require('generateRandom');

let randomNum = generateRandom(1,100);

if(randomNum <= data.testFreq) {
  return true;
}

else return false;



___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Test Frequency 100
  code: |-
    // Call runCode to run the template's code.
    let variableResult = runCode({testFreq:100});

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
    //This should always be true if Test Frequency is 100%
    assertThat(variableResult).isTrue();
- name: Test Frequency 0
  code: |-
    // Call runCode to run the template's code.
    let variableResult = runCode({testFreq:0});

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
    //This should always be true if Test Frequency is 100%
    assertThat(variableResult).isFalse();
- name: Test Frequency 50
  code: |+
    const freq = 100;
    const iterations = 1000;
    let numTest = 0;
    let numControl = 0;


    //Test running this a bunch of times and see if it matches what we expect
    let variableResult;

    for(let i=0; i<iterations; i++){
      variableResult = runCode({testFreq:freq});
      if (variableResult){
        numTest++;
      }
      else{
        numControl++;
      }
      assertThat(variableResult).isNotEqualTo(undefined);
    }
    let testFreq = numTest / (numTest + numControl);
    let freqDelta = Math.abs(testFreq * 100 - freq);

    log('numTest: ', numTest);
    log('numControl: ', numControl);
    log('testFreq: ', testFreq);
    log('freqDelta: ', freqDelta);

    assertThat(freqDelta < 1).isTrue();

setup: |
  const log = require('logToConsole');
  const Math = require('Math');


___NOTES___

Created on 11/8/2019, 3:54:03 PM


