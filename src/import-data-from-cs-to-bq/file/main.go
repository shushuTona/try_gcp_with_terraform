package insertcsvdatafunction

import (
	"context"
	"fmt"

	"cloud.google.com/go/bigquery"
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
	objectKey := eventData.Name
	projectID := "composed-facet-402402"
	client, err := bigquery.NewClient(ctx, projectID)
	if err != nil {
		return err
	}

	gcsRef := bigquery.NewGCSReference(fmt.Sprintf("gs://%s/%s", bucketName, objectKey))
	gcsRef.AllowJaggedRows = true
	gcsRef.SkipLeadingRows = 1
	gcsRef.Schema = bigquery.Schema{
		{Name: "id", Type: bigquery.IntegerFieldType, Required: true},
		{Name: "name", Type: bigquery.StringFieldType},
	}

	dataset := client.Dataset("test_dataset")
	loader := dataset.Table("test_table").LoaderFrom(gcsRef)
	loader.CreateDisposition = bigquery.CreateNever
	job, err := loader.Run(ctx)
	if err != nil {
		return err
	}

	status, err := job.Wait(ctx)
	if err != nil {
		return err
	}

	if status.Done() {
		if status.Err() != nil {
			return err
		}
	}

	return nil
}
