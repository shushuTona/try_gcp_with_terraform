package insertcsvdatafunction

import (
    "context"
	"fmt"

    "github.com/GoogleCloudPlatform/functions-framework-go/functions"
    "github.com/cloudevents/sdk-go/v2/event"
)

func init() {
    // Register a CloudEvent function with the Functions Framework
    functions.CloudEvent("cloudEventFunction", cloudEventFunction)
}

// Function myCloudEventFunction accepts and handles a CloudEvent object
func cloudEventFunction(ctx context.Context, e event.Event) error {
    // Your code here
    // Access the CloudEvent data payload via e.Data() or e.DataAs(...)
	fmt.Printf("event.Event : %#v\n", e)

    // Return nil if no error occurred
    return nil
}
