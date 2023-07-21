
aws_eks_cluster_config = {

      "demo-cluster" = {

        eks_cluster_name         = "demo-cluster1"
        eks_subnet_ids = ["subnet-03bedd78bb506f38a","subnet-0157aac81173137d9","subnet-0ba9c5b4f52ed8a55","subnet-01b42a7f66752e960"]
        tags = {
             "Name" =  "demo-cluster"
         }  
      }
}

eks_node_group_config = {

  "node1" = {

        eks_cluster_name         = "demo-cluster"
        node_group_name          = "mynode"
        nodes_iam_role           = "eks-node-group-general1"
        node_subnet_ids          = ["subnet-01b42a7f66752e960","subnet-0157aac81173137d9","subnet-0ba9c5b4f52ed8a55","subnet-01b42a7f66752e960"]

        tags = {
             "Name" =  "node1"
         } 
  }
}