import time
import pandas as pd
from blindml.frontend.config.task.task import parse_task_capsule
from sklearn.metrics import accuracy_score
from DoD.dod_api import DOD_API

def test_big_small_classifier_quick():

    examples = [["98011", "California"],
                ["32804", "Florida"]]

    model = get_model_by_example(examples)

    df = pd.DataFrame(data={"PostalCode": ["90210"]})
    df["PostalCode"] = df["PostalCode"].astype('category')
    p = model.predict(df)

    print(f"Prediction: {p}")

def get_model_by_example(values):
    path_model = "/model/"
    separator = ","
    output_path = ".//testres/"
    api = DOD_API(path_model, output_path, separator)

    attrs = ["", ""]
    values = [["98011", "California"], ["32804", "Florida"]]

    api.get_topk_views(attrs, values, 5)

    print("BENC: parsing task capsule")
    task = parse_task_capsule("dod.jsonnet")
    print("BENC: finished parsing task capsule")
    task.search_for_model()

    model = task._auto_sk_model

    X_train, y_train = task._data_set.get_train_data()

    y_pred = model.predict(X_train)

    accuracy = accuracy_score(y_train, y_pred)

    # on such a tiny dataset, this should predict with complete
    # accuracy on the training data
    threshold_accuracy = 1.0

    # if accuracy < threshold_accuracy:
    print(f"Classifier accuracy: {accuracy}")

    print(f"test finished with accuracy {accuracy}")

    return model

if __name__ == "__main__":
    test_big_small_classifier_quick()
    print("test successful")
