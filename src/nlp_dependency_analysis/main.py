import papermill

if __name__ == '__main__':
    result = papermill.execute_notebook('./notes/list.ipynb','./tmp/output.ipynb')
    output_text = result['cells'][-2]['outputs'][2]['text']
    walltime_text = output_text.split("\n")[1]
    print(walltime_text)
