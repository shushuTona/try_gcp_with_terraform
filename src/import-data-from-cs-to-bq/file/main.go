package insertcsvdatafunction

import (
	"context"
	"fmt"
	"io/ioutil"

	"cloud.google.com/go/storage"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"github.com/cloudevents/sdk-go/v2/event"
)

func init() {
	// Register a CloudEvent function with the Functions Framework
	functions.CloudEvent("cloudEventFunction", cloudEventFunction)
}

type EventData struct {
	Bucket                  string `json:"bucket"`
	ContentType             string `json:"contentType"`
	Crc32c                  string `json:"crc32c"`
	Etag                    string `json:"etag"`
	Generation              string `json:"generation"`
	Id                      string `json:"id"`
	Kind                    string `json:"kind"`
	Md5Hash                 string `json:"md5Hash"`
	MediaLink               string `json:"mediaLink"`
	Metageneration          string `json:"metageneration"`
	Name                    string `json:"name"`
	SelfLink                string `json:"selfLink"`
	Size                    string `json:"size"`
	StorageClass            string `json:"storageClass"`
	TimeCreated             string `json:"timeCreated"`
	TimeStorageClassUpdated string `json:"timeStorageClassUpdated"`
	Updated                 string `json:"updated"`
}

// Function myCloudEventFunction accepts and handles a CloudEvent object
func cloudEventFunction(ctx context.Context, e event.Event) error {
	fmt.Printf("e : %#v\n", e)

	var eventData EventData
	if err := e.DataAs(&eventData); err != nil {
		return err
	}

	fmt.Printf("eventData : %#v\n", eventData)
	fmt.Printf("eventData.Bucket : %#v\n", eventData.Bucket)
	fmt.Printf("eventData.Name : %#v\n", eventData.Name)

	bucketName := eventData.Bucket
	fileName := eventData.Name

	client, err := storage.NewClient(ctx)
	if err != nil {
		return fmt.Errorf("storage.NewClient: %w", err)
	}
	defer client.Close()

	bucketHandle := client.Bucket(bucketName)
	rc, err := bucketHandle.Object(fileName).NewReader(ctx)
	if err != nil {
		return err
	}
	defer rc.Close()

	slurp, err := ioutil.ReadAll(rc)
	if err != nil {
		return err
	}

	fmt.Println(string(slurp))

	return nil
}
