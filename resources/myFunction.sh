#!/bin/bash
#
#  myFunction.sh
#
#  Adapted for Firebase App Distribution
#  Uses Google Application Credentials for authentication
#

set -u

CMD=$(basename $0)

function usage {
    printf "\nUsage:\n${CMD} -f <path to application>\n\
                        -a <app id>\n\
Optional params:\n\
                        -r <path to release notes file>\n\
                        -g <tester group>\n"
    exit 1
}

while getopts "f:a:r:g:" opt; do
    case $opt in
        f)
            printf "${OPTARG} file path\n"
            if [[ ! -f "${OPTARG}" ]]; then
                printf "${CMD}:Unable to access file:${OPTARG}\n"
                exit 100
            fi
            APP_BINARY="${OPTARG}"
            ;;
        a)
            APP_ID="${OPTARG}"
            ;;
        g)
            TESTER_GROUPS="${OPTARG}"
            ;;
        r)
            if [[ ! -f "${OPTARG}" ]]; then
                printf "WARNING:File ${OPTARG} doesn't exist - release notes will be empty\n"
            else
                RELEASE_NOTES_FILE="${OPTARG}"
            fi
            ;;
        \?)
            usage
            ;;
        :)
            usage
        ;;
    esac
done

# Check for required parameters
if [[ -z "${APP_BINARY-}" ]]; then
    printf "${CMD}:App binary not specified\n"
    usage
fi

if [[ -z "${APP_ID-}" ]]; then
    printf "${CMD}:Firebase app ID not specified\n"
    usage
fi

# Set default values
TESTER_GROUPS=${TESTER_GROUPS-""}
RELEASE_NOTES_FILE=${RELEASE_NOTES_FILE-""}

printf "$CMD:====UPLOAD APP====\n"

# Construct the Firebase App Distribution command
FIREBASE_COMMAND="firebase appdistribution:distribute \"${APP_BINARY}\" \
--app \"${APP_ID}\""

if [[ -n "${TESTER_GROUPS}" ]]; then
    FIREBASE_COMMAND+=" --groups \"${TESTER_GROUPS}\""
fi

if [[ -n "${RELEASE_NOTES_FILE}" ]]; then
    FIREBASE_COMMAND+=" --release-notes-file \"${RELEASE_NOTES_FILE}\""
fi

# Execute the Firebase command
echo "Executing: ${FIREBASE_COMMAND}"
UPLOAD_RESULT=$(eval "${FIREBASE_COMMAND}")

echo "UPLOAD_RESULT:${UPLOAD_RESULT}"

if [[ ${UPLOAD_RESULT} == *"successfully"* ]]; then
    printf "App uploaded successfully!\n"
else 
    printf "Failed to distribute application. Error: ${UPLOAD_RESULT}\n"
    exit 135
fi

printf "$CMD:Distribution completed.\n"
exit 0